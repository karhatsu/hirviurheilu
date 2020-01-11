require 'spec_helper'

describe RelativePoints do
  describe "#relative_points" do
    before do
      @series = double Series, walking_series?: true
      @dq = create_competitor(1200, 600, 60*1, Competitor::DQ)
      @dns = create_competitor(1200, 600, 60*1, Competitor::DNS)
      @dnf = create_competitor(1200, 600, 60*1, Competitor::DNF)
      @unofficial_1 = create_competitor(1200, 600, 60*5, nil, true)
      @unofficial_2 = create_competitor(1199, 600, 60*5, nil, true)
      @unofficial_3 = create_competitor(1199, 599, 60*5-2, nil, true)
      @unofficial_4 = create_competitor(1199, 599, 60*5-1, nil, true)
      @no_result = create_competitor(nil, nil, nil)
      @points_1 = create_competitor(1100, 500, 60*20)
      @points_2_shots_1 = create_competitor(1000, 600, 60*20)
      @points_2_shots_2 = create_competitor(1000, 594, 60*20)
      @points_3_time_1 = create_competitor(900, 600, 60*15-1)
      @points_3_time_2 = create_competitor(900, 600, 60*15)
      @points_4_individual_shots_1 = create_competitor(800, 500, 60*20, nil, false, [10,10,10,10,10,10,9,9,9,6])
      @points_4_individual_shots_2 = create_competitor(800, 500, 60*20, nil, false, [10,10,10,10,10,10,9,9,8,7])
      @points_4_individual_shots_3 = create_competitor(800, 500, 60*20, nil, false, [10,10,10,10,10,10,9,8,8,8])
      @competitors_in_random_order = [@unofficial_1, @points_3_time_1, @dns, @points_1, @unofficial_4,
                                      @unofficial_3, @unofficial_2, @dq, @points_2_shots_1, @no_result,
                                      @points_3_time_2, @points_2_shots_2, @points_4_individual_shots_2,
                                      @points_4_individual_shots_1, @dnf, @points_4_individual_shots_3]
    end

    it 'should rank best points, best shots points, best time, individual shots, unofficials, DNF, DNS, DQ' do
      expected_order = [@dq, @dns, @dnf, @no_result, @points_4_individual_shots_3, @points_4_individual_shots_2,
                        @points_4_individual_shots_1, @points_3_time_2, @points_3_time_1, @points_2_shots_2,
                        @points_2_shots_1, @points_1, @unofficial_4, @unofficial_3, @unofficial_2, @unofficial_1]
      # Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME = default
      expect_relative_points_order @competitors_in_random_order, expected_order
    end

    it 'should rank best points, best shots points, best time, individual shots, unofficials, DNF, DNS, DQ' do
      expected_order = [@dq, @dns, @dnf, @no_result, @unofficial_4, @unofficial_3, @unofficial_2, @unofficial_1,
                        @points_4_individual_shots_3, @points_4_individual_shots_2, @points_4_individual_shots_1,
                        @points_3_time_2, @points_3_time_1, @points_2_shots_2, @points_2_shots_1, @points_1]
      expect_relative_points_order @competitors_in_random_order, expected_order, Series::UNOFFICIALS_EXCLUDED
    end

    it 'should rank unofficial competitors among others when all competitors wanted' do
      expected_order = [@dq, @dns, @dnf, @no_result, @points_4_individual_shots_3, @points_4_individual_shots_2,
                        @points_4_individual_shots_1, @points_3_time_2, @points_3_time_1, @points_2_shots_2,
                        @points_2_shots_1, @points_1, @unofficial_4, @unofficial_3, @unofficial_2, @unofficial_1]
      expect_relative_points_order @competitors_in_random_order, expected_order, Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME
    end

    it 'yet another test' do
      allow(@series).to receive(:walking_series?).and_return(false)
      c1 = create_competitor(927, 6*91, 60*53+6)
      c2 = create_competitor(928, 6*67, 60*37+15)
      expect_relative_points_order [c2, c1], [c1, c2]
    end

    describe 'when walking series' do
      before do
        allow(@series).to receive(:walking_series?).and_return(true)
      end

      it 'should make a difference between individual shots' do
        expect(@points_4_individual_shots_1.relative_points).to be > @points_4_individual_shots_2.relative_points
        expect(@points_4_individual_shots_2.relative_points).to be > @points_4_individual_shots_3.relative_points
      end

      it 'should not matter if shots have been saved individually or as one number' do
        c1 = create_competitor(1074, 6*84, 0, nil, false, [10, 10, 10, 9, 9, 8, 8, 8, 7, 5])
        c2 = create_competitor(1074, 6*85, 0)
        expect_relative_points_order [c2, c1], [c1, c2]
      end
    end

    describe 'when not walking series' do
      it 'should not make difference between individual shots' do
        allow(@series).to receive(:walking_series?).and_return(false)
        expect(@points_4_individual_shots_1.relative_points).to eql @points_4_individual_shots_2.relative_points
        expect(@points_4_individual_shots_2.relative_points).to eql @points_4_individual_shots_3.relative_points
      end
    end

    describe 'by shots' do
      before do
        @sort_by = Competitor::SORT_BY_SHOTS
      end

      it 'returns shot points for competitors with result' do
        @competitors_in_random_order.each do |competitor|
          unless competitor.no_result_reason
            expect(competitor.relative_points(false, @sort_by)).to eq(competitor.shooting_points.to_i)
            expect(competitor.relative_points(true, @sort_by)).to eq(competitor.shooting_points.to_i)
          end
        end
      end

      it 'handles DNF, DNS, DQ as usual' do
        some_competitors = [@dns, @unofficial_3, @no_result, @dq, @dnf, @points_2_shots_2]
        expected_order = [@dq, @dns, @dnf, @no_result, @points_2_shots_2, @unofficial_3]
        expect_relative_points_order some_competitors, expected_order, Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME, @sort_by
        expect_relative_points_order some_competitors, expected_order, Series::UNOFFICIALS_EXCLUDED, @sort_by
      end
    end

    describe 'by estimates' do
      before do
        @sort_by = Competitor::SORT_BY_ESTIMATES
      end

      it 'returns estimate points for competitors with result' do
        @competitors_in_random_order.each do |competitor|
          unless competitor.no_result_reason
            expect(competitor.relative_points(false, @sort_by)).to eq(competitor.estimate_points.to_i)
            expect(competitor.relative_points(true, @sort_by)).to eq(competitor.estimate_points.to_i)
          end
        end
      end

      it 'handles DNF, DNS, DQ as usual' do
        some_competitors = [@dns, @no_result, @dq, @dnf, @points_2_shots_2]
        expected_order = [@dq, @dns, @dnf, @no_result, @points_2_shots_2]
        expect_relative_points_order some_competitors, expected_order, Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME, @sort_by
      end
    end

    describe 'by time' do
      before do
        @sort_by = Competitor::SORT_BY_TIME
      end

      it 'returns negative time in seconds for competitors with result' do
        @competitors_in_random_order.each do |competitor|
          unless competitor.no_result_reason || competitor.time_in_seconds.nil?
            expect(competitor.relative_points(false, @sort_by)).to eq(-competitor.time_in_seconds.to_i)
            expect(competitor.relative_points(true, @sort_by)).to eq(-competitor.time_in_seconds.to_i)
          end
        end
      end

      it 'handles DNF, DNS, DQ as usual; does not set nil time to the top' do
        some_competitors = [@no_result, @dns, @points_3_time_1, @dq, @dnf, @points_3_time_2]
        expected_order = [@dq, @dns, @dnf, @no_result, @points_3_time_2, @points_3_time_1]
        expect_relative_points_order some_competitors, expected_order, Series::UNOFFICIALS_EXCLUDED, @sort_by
        expect_relative_points_order some_competitors, expected_order, Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME, @sort_by
      end
    end

    def create_competitor(points, shooting_points, time_in_seconds, no_result_reason=nil, unofficial=false,
                          shots=[0,0,0,0,0,0,0,0,0,0])
      competitor = build :competitor
      allow(competitor).to receive(:series).and_return(@series)
      allow(competitor).to receive(:no_result_reason).and_return(no_result_reason)
      allow(competitor).to receive(:points).and_return(points)
      allow(competitor).to receive(:shooting_points).and_return(shooting_points)
      allow(competitor).to receive(:time_in_seconds).and_return(time_in_seconds)
      allow(competitor).to receive(:unofficial?).and_return(unofficial)
      allow(competitor).to receive(:estimate_points).and_return(550)
      allow(competitor).to receive(:shots).and_return(shots)
      competitor
    end

    def expect_relative_points_order(competitors, expected_order, unofficials=Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME, sort_by=nil)
      expect(competitors.map {|c|c.relative_points(unofficials, sort_by)}.sort)
          .to eq(expected_order.map {|c|c.relative_points(unofficials, sort_by)})
    end
  end

  describe '#relative_shooting_points' do
    context 'when no shots' do
      it 'returns 0' do
        expect(build(:competitor).relative_shooting_points).to eq 0
      end
    end

    context 'when shots' do
      it 'multiplies each shot by its value' do
        competitor = create :competitor, shots: [10, 10, 8, 7, 3, 3]
        expect(competitor.reload.relative_shooting_points).to eq(2*10*10 + 8*8 + 7*7 + 2*3*3)
      end
    end
  end
end
