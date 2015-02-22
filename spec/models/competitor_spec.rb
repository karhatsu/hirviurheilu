require 'spec_helper'

describe Competitor do
  describe "create" do
    it "should create competitor with valid attrs" do
      FactoryGirl.create(:competitor)
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:club) }
    it { is_expected.to belong_to(:series) }
    it { is_expected.to belong_to(:age_group) }
    it { is_expected.to have_many(:shots) }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }

    describe "number" do
      it { is_expected.to allow_value(nil).for(:number) }
      it { is_expected.to validate_numericality_of(:number) }
      it { is_expected.not_to allow_value(23.5).for(:number) }
      it { is_expected.not_to allow_value(0).for(:number) }
      it { is_expected.to allow_value(1).for(:number) }

      describe "uniqueness" do
        before do
          @c = FactoryGirl.create(:competitor, :number => 5)
        end
        
        it "should require uniqueness for numbers in the same race" do
          series = FactoryGirl.create(:series, :race => @c.series.race)
          competitor = FactoryGirl.build(:competitor, :series => series, :number => 6)
          expect(competitor).to be_valid
          competitor.number = 5
          expect(competitor).not_to be_valid
        end
        
        it "should allow updating the competitor" do
          expect(@c).to be_valid
        end
        
        it "should allow same number in another race" do
          race = FactoryGirl.create(:race)
          series = FactoryGirl.create(:series)
          expect(FactoryGirl.build(:competitor, :series => series, :number => 5)).to be_valid
        end
        
        it "should allow two nils for same series" do
          c = FactoryGirl.create(:competitor, :number => nil)
          expect(FactoryGirl.build(:competitor, :number => nil, :series => c.series)).
            to be_valid
        end
      end

      context "when series has start list" do
        it "should not be nil" do
          series = FactoryGirl.build(:series, :has_start_list => true)
          competitor = FactoryGirl.build(:competitor, :series => series, :number => nil)
          expect(competitor).to have(1).errors_on(:number)
        end
      end
    end

    describe "start_time" do
      it { is_expected.to allow_value(nil).for(:start_time) }

      context "when series has start list" do
        it "should not be nil" do
          series = FactoryGirl.build(:series, :has_start_list => true)
          competitor = FactoryGirl.build(:competitor, :series => series, :start_time => nil)
          expect(competitor).to have(1).errors_on(:start_time)
        end
      end
    end

    describe "shots_total_input" do
      it { is_expected.to allow_value(nil).for(:shots_total_input) }
      it { is_expected.not_to allow_value(1.1).for(:shots_total_input) }
      it { is_expected.not_to allow_value(-1).for(:shots_total_input) }
      it { is_expected.to allow_value(100).for(:shots_total_input) }
      it { is_expected.not_to allow_value(101).for(:shots_total_input) }

      it "cannot be given if also individual shots have been defined" do
        comp = FactoryGirl.build(:competitor, :shots_total_input => 50)
        comp.shots << FactoryGirl.build(:shot, :competitor => comp, :value => 8)
        comp.shots << FactoryGirl.build(:shot, :competitor => comp, :value => 8)
        expect(comp).to have(1).errors_on(:base)
      end

      it "can be given if individual shots only with nils" do
        comp = FactoryGirl.build(:competitor, :shots_total_input => 50)
        comp.shots << FactoryGirl.build(:shot, :competitor => comp, :value => nil)
        expect(comp).to be_valid
      end
    end
    
    describe "shots" do
      it "should have at maximum ten shots" do
        comp = FactoryGirl.build(:competitor)
        10.times do
          comp.shots << FactoryGirl.build(:shot, :competitor => comp, :value => 8)
        end
        expect(comp).to be_valid
        comp.shots << FactoryGirl.build(:shot, :competitor => comp, :value => 8)
        expect(comp).to have(1).errors_on(:shots)
      end
    end

    describe "estimate1" do
      it { is_expected.to allow_value(nil).for(:estimate1) }
      it { is_expected.not_to allow_value(1.1).for(:estimate1) }
      it { is_expected.not_to allow_value(-1).for(:estimate1) }
      it { is_expected.not_to allow_value(0).for(:estimate1) }
      it { is_expected.to allow_value(1).for(:estimate1) }
    end

    describe "estimate2" do
      it { is_expected.to allow_value(nil).for(:estimate2) }
      it { is_expected.not_to allow_value(1.1).for(:estimate2) }
      it { is_expected.not_to allow_value(-1).for(:estimate2) }
      it { is_expected.not_to allow_value(0).for(:estimate2) }
      it { is_expected.to allow_value(1).for(:estimate2) }
    end

    describe "estimate3" do
      it { is_expected.to allow_value(nil).for(:estimate3) }
      it { is_expected.not_to allow_value(1.1).for(:estimate3) }
      it { is_expected.not_to allow_value(-1).for(:estimate3) }
      it { is_expected.not_to allow_value(0).for(:estimate3) }
      it { is_expected.to allow_value(1).for(:estimate3) }
    end

    describe "estimate4" do
      it { is_expected.to allow_value(nil).for(:estimate4) }
      it { is_expected.not_to allow_value(1.1).for(:estimate4) }
      it { is_expected.not_to allow_value(-1).for(:estimate4) }
      it { is_expected.not_to allow_value(0).for(:estimate4) }
      it { is_expected.to allow_value(1).for(:estimate4) }
    end

    describe "correct_estimate1" do
      it { is_expected.to allow_value(nil).for(:correct_estimate1) }
      it { is_expected.not_to allow_value(1.1).for(:correct_estimate1) }
      it { is_expected.not_to allow_value(-1).for(:correct_estimate1) }
      it { is_expected.not_to allow_value(0).for(:correct_estimate1) }
      it { is_expected.to allow_value(1).for(:correct_estimate1) }
    end

    describe "correct_estimate2" do
      it { is_expected.to allow_value(nil).for(:correct_estimate2) }
      it { is_expected.not_to allow_value(1.1).for(:correct_estimate2) }
      it { is_expected.not_to allow_value(-1).for(:correct_estimate2) }
      it { is_expected.not_to allow_value(0).for(:correct_estimate2) }
      it { is_expected.to allow_value(1).for(:correct_estimate2) }
    end

    describe "correct_estimate3" do
      it { is_expected.to allow_value(nil).for(:correct_estimate3) }
      it { is_expected.not_to allow_value(1.1).for(:correct_estimate3) }
      it { is_expected.not_to allow_value(-1).for(:correct_estimate3) }
      it { is_expected.not_to allow_value(0).for(:correct_estimate3) }
      it { is_expected.to allow_value(1).for(:correct_estimate3) }
    end

    describe "correct_estimate4" do
      it { is_expected.to allow_value(nil).for(:correct_estimate4) }
      it { is_expected.not_to allow_value(1.1).for(:correct_estimate4) }
      it { is_expected.not_to allow_value(-1).for(:correct_estimate4) }
      it { is_expected.not_to allow_value(0).for(:correct_estimate4) }
      it { is_expected.to allow_value(1).for(:correct_estimate4) }
    end

    describe "arrival_time" do
      it { is_expected.to allow_value(nil).for(:arrival_time) }

      it "can be nil even when start time is not nil" do
        expect(FactoryGirl.build(:competitor, :start_time => '14:00', :arrival_time => nil)).
          to be_valid
      end

      it "should not be before start time" do
        expect(FactoryGirl.build(:competitor, :start_time => '14:00', :arrival_time => '13:59')).
          to have(1).errors_on(:arrival_time)
      end

      it "should not be same as start time" do
        expect(FactoryGirl.build(:competitor, :start_time => '14:00', :arrival_time => '14:00')).
          to have(1).errors_on(:arrival_time)
      end

      it "is valid when later than start time" do
        expect(FactoryGirl.build(:competitor, :start_time => '14:00', :arrival_time => '14:01')).
          to be_valid
      end

      it "cannot be given if no start time" do
        expect(FactoryGirl.build(:competitor, :start_time => nil, :arrival_time => '13:59')).
          not_to be_valid
      end
    end

    describe "no_result_reason" do
      it { is_expected.to allow_value(nil).for(:no_result_reason) }
      it { is_expected.to allow_value(Competitor::DNS).for(:no_result_reason) }
      it { is_expected.to allow_value(Competitor::DNF).for(:no_result_reason) }
      it { is_expected.to allow_value(Competitor::DQ).for(:no_result_reason) }
      it { is_expected.not_to allow_value('test').for(:no_result_reason) }

      it "converts empty string to nil" do
        comp = FactoryGirl.build(:competitor, :no_result_reason => '')
        expect(comp).to be_valid
        comp.save!
        expect(comp.no_result_reason).to eq(nil)
      end
    end
    
    describe "names" do
      it "should be unique for same series" do
        c1 = FactoryGirl.create(:competitor)
        s2 = FactoryGirl.create(:series, :race => c1.race)
        expect(FactoryGirl.build(:competitor, :first_name => c1.first_name,
          :last_name => c1.last_name, :series => c1.series)).not_to be_valid
        expect(FactoryGirl.build(:competitor, :first_name => 'Other first name',
          :last_name => c1.last_name, :series => c1.series)).to be_valid
        expect(FactoryGirl.build(:competitor, :first_name => c1.first_name,
          :last_name => 'Other last name', :series => c1.series)).to be_valid
        expect(FactoryGirl.build(:competitor, :first_name => c1.first_name,
          :last_name => c1.last_name, :series => s2)).to be_valid
      end
    end
  end

  describe "race" do
    it "should be the series.race" do
      race = FactoryGirl.build(:race)
      series = FactoryGirl.build(:series, :race => race)
      competitor = FactoryGirl.build(:competitor, :series => series)
      expect(competitor.race).to eq(race)
    end
  end
  
  describe "save" do
    context "when competitor has no start time or number" do
      it "should not save series for nothing" do
        series = FactoryGirl.create(:series, :start_time => nil, :first_number => nil)
        comp = FactoryGirl.build(:competitor, :series => series, :start_time => nil, :number => nil)
        expect(comp.series).not_to receive(:update_start_time_and_number)
        comp.save!
      end
    end
    
    context "when competitor has no start time but has number" do
      it "should not save series" do
        series = FactoryGirl.create(:series, :start_time => nil, :first_number => nil)
        comp = FactoryGirl.build(:competitor, :series => series, :start_time => nil, :number => 12)
        expect(comp.series).not_to receive(:update_start_time_and_number)
        comp.save!
      end
    end

    context "when competitor has start time but has no number" do
      it "should not save series" do
        series = FactoryGirl.create(:series, :start_time => nil, :first_number => nil)
        comp = FactoryGirl.build(:competitor, :series => series, :start_time => '12:00', :number => nil)
        expect(comp.series).not_to receive(:update_start_time_and_number)
        comp.save!
      end
    end
    
    context "when competitor has both start time and number" do
      it "should let series update its start time and first number" do
        series = FactoryGirl.create(:series, :start_time => nil, :first_number => nil, :has_start_list => true)
        comp = FactoryGirl.create(:competitor, :series => series, :start_time => '12:35:30', :number => 15)
        expect(comp.series).to receive(:update_start_time_and_number)
        comp.save!
      end
    end
  end
  
  describe "concurrency check" do
    context "on create" do
      it "should do nothing" do
        @competitor = FactoryGirl.build(:competitor)
        expect(@competitor).not_to receive(:values_equal?)
        @competitor.save!
      end
    end
    
    context "on update" do
      before do
        @competitor = FactoryGirl.create(:competitor)
      end
    
      it "should pass if old and current values equal" do
        expect(@competitor).to receive(:values_equal?).and_return(true)
        @competitor.save
        expect(@competitor.errors.size).to eq(0)
      end
      
      it "should fail if old and current values differ" do
        expect(@competitor).to receive(:values_equal?).and_return(false)
        expect(@competitor).to have(1).errors_on(:base)
      end
    end
  end

  describe "#sort_competitors" do
    before do
      @second_partial = instance_double(Competitor, :points => nil, :points! => 12,
        :no_result_reason => nil, :shot_points => 50, :time_points => 30,
        :time_in_seconds => 999, :unofficial => false, :estimate_points => nil)
      @worst_partial = instance_double(Competitor, :points => nil, :points! => nil,
        :no_result_reason => nil, :shot_points => 51, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false, :estimate_points => nil)
      @best_partial = instance_double(Competitor, :points => nil, :points! => 88,
        :no_result_reason => nil, :shot_points => 50, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false, :estimate_points => nil)
      @best_time = instance_double(Competitor, :points => 199, :points! => 199,
        :no_result_reason => nil, :shot_points => 87, :time_points => 30,
        :time_in_seconds => 999, :unofficial => false, :estimate_points => 250)
      @best_points = instance_double(Competitor, :points => 201, :points! => 201,
        :no_result_reason => nil, :shot_points => 50, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false, :estimate_points => 250)
      @worst_points = instance_double(Competitor, :points => 199, :points! => 199,
        :no_result_reason => nil, :shot_points => 87, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false, :estimate_points => 250)
      @best_shots = instance_double(Competitor, :points => 199, :points! => 199,
        :no_result_reason => nil, :shot_points => 88, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false, :estimate_points => 250)
      @best_estimates = instance_double(Competitor, :points => 199, :points! => 199,
        :no_result_reason => nil, :shot_points => 86, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false, :estimate_points => 252)
      @c_dnf = instance_double(Competitor, :points => 300, :points! => 300,
        :no_result_reason => "DNF", :shot_points => 88, :time_points => 30,
        :time_in_seconds => 999, :unofficial => false, :estimate_points => 256)
      @c_dns = instance_double(Competitor, :points => 300, :points! => 300,
        :no_result_reason => "DNS", :shot_points => 88, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false, :estimate_points => 255)
      @c_dq = instance_double(Competitor, :points => 300, :points! => 300,
        :no_result_reason => "DQ", :shot_points => 88, :time_points => 30,
        :time_in_seconds => 999, :unofficial => false, :estimate_points => 256)
      @unofficial = instance_double(Competitor, :points => 300, :points! => 300,
        :no_result_reason => nil, :shot_points => 100, :time_points => 100,
        :time_in_seconds => 1000, :unofficial => true, :estimate_points => 250)
    end

    it "should return empty list when no competitors defined" do
      expect(Competitor.sort_competitors([], false)).to eq([])
    end

    # note that partial points equal points when all results are available
    it "should sort by: 1. points 2. partial points 3. shot points " +
        "4. time (secs) 5. normal competitors before DNS/DNF/DQ " +
        "6. unofficial competitors before DNS/DNF/DQ" do
      competitors = [@unofficial, @second_partial, @worst_partial, @best_partial,
        @c_dnf, @c_dns, @c_dq, @best_time, @best_points, @worst_points, @best_shots]
      expect(Competitor.sort_competitors(competitors, false)).to eq(
        [@best_points, @best_shots, @best_time, @worst_points, @best_partial,
        @second_partial, @worst_partial, @unofficial, @c_dnf, @c_dns, @c_dq]
      )
    end

    context "when unofficial competitors are handled equal" do
      it "should sort by: 1. points 2. partial points 3. shot points " +
          "4. time (secs) 5. normal competitors before DNS/DNF/DQ" do
        competitors = [@unofficial, @second_partial, @worst_partial, @best_partial,
          @c_dnf, @c_dns, @c_dq, @best_time, @best_points, @worst_points, @best_shots]
        expect(Competitor.sort_competitors(competitors, true)).to eq(
          [@unofficial, @best_points, @best_shots, @best_time, @worst_points,
          @best_partial, @second_partial, @worst_partial, @c_dnf, @c_dns, @c_dq]
        )
      end
    end
    
    describe "by time" do
      it "should sort by: 1. time (secs) 2. points 3. partial points 4. shot points 5. DNS/DNF/DQ " do
        competitors = [@second_partial, @worst_partial, @best_partial,
          @c_dnf, @c_dns, @c_dq, @best_time, @best_points, @worst_points, @best_shots]
        expect(Competitor.sort_competitors(competitors, false, Competitor::SORT_BY_TIME)).to eq(
          [@best_time, @second_partial, @best_points, @best_shots, @worst_points,
            @best_partial, @worst_partial, @c_dnf, @c_dns, @c_dq]
        )
      end
    end
    
    describe "by shots" do
      it "should sort by: 1. shot points 2. points 3. partial points 4. time (secs) 5. DNS/DNF/DQ " do
        competitors = [@second_partial, @worst_partial, @best_partial,
          @c_dnf, @c_dns, @c_dq, @best_time, @best_points, @worst_points, @best_shots]
        expect(Competitor.sort_competitors(competitors, false, Competitor::SORT_BY_SHOTS)).to eq(
        [@best_shots, @best_time, @worst_points, @worst_partial, @best_points,
          @best_partial, @second_partial, @c_dnf, @c_dns, @c_dq]
        )
      end
    end
    
    describe "by estimates" do
      it "should sort by: 1. estimate points 2. points 3. partial points 4. shot points 5. DNS/DNF/DQ " do
        competitors = [@worst_partial, @best_partial,
          @c_dnf, @c_dns, @c_dq, @best_time, @best_points, @worst_points, @best_shots, @best_estimates]
        expect(Competitor.sort_competitors(competitors, false, Competitor::SORT_BY_ESTIMATES)).to eq(
        [@best_estimates, @best_points, @best_shots, @best_time, @worst_points, @best_partial,
          @worst_partial, @c_dnf, @c_dns, @c_dq]
        )
      end
    end
  end

  describe "#shots_sum" do
    it "should return nil when total input is nil and no shots" do
      expect(FactoryGirl.build(:competitor).shots_sum).to be_nil
    end

    it "should be shots_total_input when it is given" do
      expect(FactoryGirl.build(:competitor, :shots_total_input => 55).shots_sum).to eq(55)
    end

    it "should be sum of defined individual shots if no input sum" do
      comp = FactoryGirl.build(:competitor, :shots_total_input => nil)
      comp.shots << FactoryGirl.build(:shot, :value => 8, :competitor => comp)
      comp.shots << FactoryGirl.build(:shot, :value => 9, :competitor => comp)
      comp.shots << FactoryGirl.build(:shot, :value => nil, :competitor => comp)
      expect(comp.shots_sum).to eq(17)
    end
  end

  describe "#shot_points" do
    it "should be nil if shots not defined" do
      competitor = FactoryGirl.build(:competitor)
      expect(competitor).to receive(:shots_sum).and_return(nil)
      expect(competitor.shot_points).to be_nil
    end

    it "should be 6 times shots_sum" do
      competitor = FactoryGirl.build(:competitor)
      expect(competitor).to receive(:shots_sum).and_return(50)
      expect(competitor.shot_points).to eq(300)
    end
  end

  describe "#estimate_diff1_m" do
    it "should be nil when no correct estimate1" do
      expect(FactoryGirl.build(:competitor, :estimate1 => 100, :correct_estimate1 => nil).
        estimate_diff1_m).to be_nil
    end

    it "should be nil when no estimate1" do
      expect(FactoryGirl.build(:competitor, :estimate1 => nil, :correct_estimate1 => 100).
        estimate_diff1_m).to be_nil
    end

    it "should be positive diff when estimate1 is more than correct" do
      expect(FactoryGirl.build(:competitor, :estimate1 => 105, :correct_estimate1 => 100).
        estimate_diff1_m).to eq(5)
    end

    it "should be negative diff when estimate1 is less than correct" do
      expect(FactoryGirl.build(:competitor, :estimate1 => 91, :correct_estimate1 => 100).
        estimate_diff1_m).to eq(-9)
    end
  end

  describe "#estimate_diff2_m" do
    it "should be nil when no correct estimate2" do
      expect(FactoryGirl.build(:competitor, :estimate2 => 100, :correct_estimate2 => nil).
        estimate_diff2_m).to be_nil
    end

    it "should be nil when no estimate2" do
      expect(FactoryGirl.build(:competitor, :estimate2 => nil, :correct_estimate2 => 200).
        estimate_diff2_m).to be_nil
    end

    it "should be positive diff when estimate2 is more than correct" do
      expect(FactoryGirl.build(:competitor, :estimate2 => 205, :correct_estimate2 => 200).
        estimate_diff2_m).to eq(5)
    end

    it "should be negative diff when estimate2 is less than correct" do
      expect(FactoryGirl.build(:competitor, :estimate2 => 191, :correct_estimate2 => 200).
        estimate_diff2_m).to eq(-9)
    end
  end

  describe "#estimate_diff3_m" do
    it "should be nil when no correct estimate3" do
      expect(FactoryGirl.build(:competitor, :estimate3 => 100, :correct_estimate3 => nil).
        estimate_diff3_m).to be_nil
    end

    it "should be nil when no estimate3" do
      expect(FactoryGirl.build(:competitor, :estimate3 => nil, :correct_estimate3 => 100).
        estimate_diff3_m).to be_nil
    end

    it "should be positive diff when estimate3 is more than correct" do
      expect(FactoryGirl.build(:competitor, :estimate3 => 105, :correct_estimate3 => 100).
        estimate_diff3_m).to eq(5)
    end

    it "should be negative diff when estimate3 is less than correct" do
      expect(FactoryGirl.build(:competitor, :estimate3 => 91, :correct_estimate3 => 100).
        estimate_diff3_m).to eq(-9)
    end
  end

  describe "#estimate_diff4_m" do
    it "should be nil when no correct estimate4" do
      expect(FactoryGirl.build(:competitor, :estimate4 => 100, :correct_estimate4 => nil).
        estimate_diff4_m).to be_nil
    end

    it "should be nil when no estimate4" do
      expect(FactoryGirl.build(:competitor, :estimate4 => nil, :correct_estimate4 => 200).
        estimate_diff4_m).to be_nil
    end

    it "should be positive diff when estimate4 is more than correct" do
      expect(FactoryGirl.build(:competitor, :estimate4 => 205, :correct_estimate4 => 200).
        estimate_diff4_m).to eq(5)
    end

    it "should be negative diff when estimate4 is less than correct" do
      expect(FactoryGirl.build(:competitor, :estimate4 => 191, :correct_estimate4 => 200).
        estimate_diff4_m).to eq(-9)
    end
  end

  describe "#estimate_points" do
    describe "estimate missing" do
      it "should be nil if estimate1 is missing" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => nil, :estimate2 => 145,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to be_nil
      end

      it "should be nil if estimate2 is missing" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 156, :estimate2 => nil,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to be_nil
      end

      context "when 4 estimates for the series" do
        before do
          @series = FactoryGirl.build(:series, :estimates => 4)
        end

        it "should be nil if estimate3 is missing" do
          competitor = FactoryGirl.build(:competitor, :series => @series,
            :estimate1 => 100, :estimate2 => 145,
            :estimate3 => nil, :estimate4 => 150,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => 100, :correct_estimate4 => 200)
          expect(competitor.estimate_points).to be_nil
        end

        it "should be nil if estimate4 is missing" do
          competitor = FactoryGirl.build(:competitor, :series => @series,
            :estimate1 => 156, :estimate2 => 100,
            :estimate3 => 150, :estimate4 => nil,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => 100, :correct_estimate4 => 200)
          expect(competitor.estimate_points).to be_nil
        end
      end
    end

    describe "correct estimate missing" do
      it "should be nil if correct estimate 1 is missing" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 100, :estimate2 => 200,
          :correct_estimate1 => nil, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to be_nil
      end

      it "should be nil if correct estimate 2 is missing" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 100, :estimate2 => 200,
          :correct_estimate1 => 100, :correct_estimate2 => nil)
        expect(competitor.estimate_points).to be_nil
      end

      context "when 4 estimates for the series" do
        before do
          @series = FactoryGirl.build(:series, :estimates => 4)
        end

        it "should be nil if correct estimate 3 is missing" do
          competitor = FactoryGirl.build(:competitor, :series => @series,
            :estimate1 => 100, :estimate2 => 200,
            :estimate3 => 100, :estimate4 => 200,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => nil, :correct_estimate4 => 200)
          expect(competitor.estimate_points).to be_nil
        end

        it "should be nil if correct estimate 4 is missing" do
          competitor = FactoryGirl.build(:competitor, :series => @series,
            :estimate1 => 100, :estimate2 => 200,
            :estimate3 => 100, :estimate4 => 200,
            :correct_estimate1 => 100, :correct_estimate2 => 150,
            :correct_estimate3 => 100, :correct_estimate4 => nil)
          expect(competitor.estimate_points).to be_nil
        end
      end
    end

    describe "no estimates nor correct estimates missing" do
      it "should be 300 when perfect estimates" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 100, :estimate2 => 200,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to eq(300)
      end

      it "should be 298 when the first is 1 meter too low" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 99, :estimate2 => 200,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to eq(298)
      end

      it "should be 298 when the second is 1 meter too low" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 100, :estimate2 => 199,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to eq(298)
      end

      it "should be 298 when the first is 1 meter too high" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 101, :estimate2 => 200,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to eq(298)
      end

      it "should be 298 when the second is 1 meter too high" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 100, :estimate2 => 201,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to eq(298)
      end

      it "should be 296 when both have 1 meter difference" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 99, :estimate2 => 201,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to eq(296)
      end

      it "should never be negative" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 111111, :estimate2 => 222222,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to eq(0)
      end
      
      context "when 4 estimates for the series" do
        before do
          @series = FactoryGirl.build(:series, :estimates => 4)
        end
        
        it "should be 600 when perfect estimates" do
          competitor = FactoryGirl.build(:competitor, :series => @series,
            :estimate1 => 100, :estimate2 => 200,
            :estimate3 => 80, :estimate4 => 140,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => 80, :correct_estimate4 => 140)
          expect(competitor.estimate_points).to eq(600)
        end

        it "should be 584 when each estimate is 2 meters wrong" do
          competitor = FactoryGirl.build(:competitor, :series => @series,
            :estimate1 => 98, :estimate2 => 202,
            :estimate3 => 108, :estimate4 => 152,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => 110, :correct_estimate4 => 150)
          expect(competitor.estimate_points).to eq(584) # 600 - 4*4
        end
      end
    end
  end

  describe "#time_in_seconds" do
    it "should be nil when start time not known yet" do
      expect(FactoryGirl.build(:competitor, :start_time => nil).time_in_seconds).to be_nil
    end

    it "should be nil when arrival time is not known yet" do
      expect(FactoryGirl.build(:competitor, :start_time => '14:00', :arrival_time => nil).
        time_in_seconds).to be_nil
    end

    it "should be difference of arrival and start times" do
      expect(FactoryGirl.build(:competitor, :start_time => '13:58:02', :arrival_time => '15:02:04').
        time_in_seconds).to eq(64 * 60 + 2)
    end
  end

  describe "#time_points" do
    before do
      @all_competitors = true
      @series = FactoryGirl.build(:series)
      @competitor = FactoryGirl.build(:competitor, :series => @series)
      @best_time_seconds = 3603.0 # rounded: 3600
      allow(@competitor).to receive(:comparison_time_in_seconds).with(@all_competitors).and_return(@best_time_seconds)
    end

    it "should be nil when time cannot be calculated yet" do
      expect(@competitor).to receive(:time_in_seconds).and_return(nil)
      expect(@competitor.time_points(@all_competitors)).to eq(nil)
    end

    it "should be nil when competitor has time but best time cannot be calculated" do
      # this happens if competitor has time but did not finish (no_result_reason=DNF)
      # and no-one else has result either
      expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds)
      expect(@competitor).to receive(:comparison_time_in_seconds).with(@all_competitors).and_return(nil)
      expect(@competitor.time_points(@all_competitors)).to eq(nil)
    end

    context "when the competitor has the best time" do
      it "should be 300" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds)
        expect(@competitor.time_points(@all_competitors)).to eq(300)
      end
    end

    context "when the competitor has worse time which is rounded down to 10 secs" do
      it "should be 300 when the rounded time is the same as the best time rounded" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 6)
        expect(@competitor.time_points(@all_competitors)).to eq(300)
      end

      it "should be 299 when the rounded time is 10 seconds worse than the best time" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 7)
        expect(@competitor.time_points(@all_competitors)).to eq(299)
      end

      it "should be 299 when the rounded time is still 10 seconds worse" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 16)
        expect(@competitor.time_points(@all_competitors)).to eq(299)
      end

      it "should be 298 when the rounded time is 20 seconds worse" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 17)
        expect(@competitor.time_points(@all_competitors)).to eq(298)
      end
    end
    
    context "when the competitor is an unofficial competitor and has better time than official best time" do
      it "should be 300" do
        @competitor.unofficial = true
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds - 60)
        expect(@competitor.time_points(@all_competitors)).to eq(300)
      end
    end

    it "should never be negative" do
      expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 100000)
      expect(@competitor.time_points(@all_competitors)).to eq(0)
    end

    context "when no time points" do
      it "should be nil" do
        @competitor.series.time_points_type = Series::TIME_POINTS_TYPE_NONE
        allow(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds)
        expect(@competitor.time_points(@all_competitors)).to be_nil
      end
    end

    context "when 300 time points for all competitors in the series" do
      it "should be 300" do
        @competitor.series.time_points_type = Series::TIME_POINTS_TYPE_ALL_300
        allow(@competitor).to receive(:time_in_seconds).and_return(nil)
        expect(@competitor.time_points(@all_competitors)).to eq(300)
      end
    end

    context "no result" do
      before do
        @competitor = FactoryGirl.build(:competitor, :series => @series,
          :no_result_reason => Competitor::DNF)
        @best_time_seconds = 3603.0
        allow(@competitor).to receive(:comparison_time_in_seconds).with(@all_competitors).and_return(@best_time_seconds)
      end

      it "should be like normally when the competitor has not the best time" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 20)
        expect(@competitor.time_points(@all_competitors)).to eq(298)
      end

      it "should be nil when competitor's time is better than the best time" do
        # note: when no result, the time really can be better than the best time
        # since such a competitor's time cannot be the best time
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds - 1)
        expect(@competitor.time_points(@all_competitors)).to be_nil
      end
    end
  end

  describe "#points" do
    before do
      @all_competitors = true
      @competitor = FactoryGirl.build(:competitor)
      allow(@competitor).to receive(:shot_points).and_return(100)
      allow(@competitor).to receive(:estimate_points).and_return(150)
      allow(@competitor).to receive(:time_points).with(@all_competitors).and_return(200)
    end

    it "should be nil when no shot points" do
      expect(@competitor).to receive(:shot_points).and_return(nil)
      expect(@competitor.points(@all_competitors)).to be_nil
    end

    it "should be nil when no estimate points" do
      expect(@competitor).to receive(:estimate_points).and_return(nil)
      expect(@competitor.points(@all_competitors)).to be_nil
    end

    context "when series calculates time points" do
      it "should be nil when no time points" do
        expect(@competitor).to receive(:time_points).with(@all_competitors).and_return(nil)
        expect(@competitor.points(@all_competitors)).to be_nil
      end
    end

    context "when series does not calculate time points and shot/estimate points available" do
      it "should be shot + estimate points" do
        @competitor.series.time_points_type = Series::TIME_POINTS_TYPE_NONE
        expect(@competitor).to receive(:time_points).with(@all_competitors).and_return(nil)
        expect(@competitor.points(@all_competitors)).to eq(100 + 150)
      end
    end

    it "should be sum of sub points when all of them are available" do
      expect(@competitor.points(@all_competitors)).to eq(100 + 150 + 200)
    end
  end

  describe "#points!" do
    before do
      @all_competitors = true
      @competitor = FactoryGirl.build(:competitor)
      allow(@competitor).to receive(:shot_points).and_return(100)
      allow(@competitor).to receive(:estimate_points).and_return(150)
      allow(@competitor).to receive(:time_points).with(@all_competitors).and_return(200)
    end

    it "should be estimate + time points when no shot points" do
      expect(@competitor).to receive(:shot_points).and_return(nil)
      expect(@competitor.points!(@all_competitors)).to eq(150 + 200)
    end

    it "should be shot + time points when no estimate points" do
      expect(@competitor).to receive(:estimate_points).and_return(nil)
      expect(@competitor.points!(@all_competitors)).to eq(100 + 200)
    end

    it "should be shot + estimate points when no time points" do
      expect(@competitor).to receive(:time_points).with(@all_competitors).and_return(nil)
      expect(@competitor.points!(@all_competitors)).to eq(100 + 150)
    end

    it "should be sum of sub points when all of them are available" do
      expect(@competitor.points!(@all_competitors)).to eq(100 + 150 + 200)
    end
  end

  describe "#shot_values" do
    it "should return an ordered array of 10 shots" do
      c = FactoryGirl.build(:competitor)
      c.shots << FactoryGirl.build(:shot, :value => 10, :competitor => c)
      c.shots << FactoryGirl.build(:shot, :value => 3, :competitor => c)
      c.shots << FactoryGirl.build(:shot, :value => 4, :competitor => c)
      c.shots << FactoryGirl.build(:shot, :value => 9, :competitor => c)
      c.shots << FactoryGirl.build(:shot, :value => 1, :competitor => c)
      c.shots << FactoryGirl.build(:shot, :value => 0, :competitor => c)
      c.shots << FactoryGirl.build(:shot, :value => 9, :competitor => c)
      c.shots << FactoryGirl.build(:shot, :value => 7, :competitor => c)
      expect(c.shot_values).to eq([10,9,9,7,4,3,1,0,nil,nil])
    end
  end

  describe "#next_competitor" do
    before do
      @series = FactoryGirl.create(:series)
      @c = FactoryGirl.create(:competitor, :series => @series, :number => 15)
      FactoryGirl.create(:competitor) # another series
    end

    it "should return itself when no other competitors" do
      expect(@c.next_competitor).to eq(@c)
    end

    context "other competitors" do
      before do
        @first = FactoryGirl.create(:competitor, :series => @series, :number => 10)
        @nil = FactoryGirl.create(:competitor, :series => @series, :number => nil)
        @prev = FactoryGirl.create(:competitor, :series => @series, :number => 12)
        @next = FactoryGirl.create(:competitor, :series => @series, :number => 17)
        @last = FactoryGirl.create(:competitor, :series => @series, :number => 20)
        @series.reload
      end

      it "should return the competitor with next biggest number when such exists" do
        expect(@c.next_competitor).to eq(@next)
      end

      it "should return the competitor with smallest number when no bigger numbers" do
        expect(@last.next_competitor).to eq(@first)
      end

      it "should return the next by id if competitor has no number" do
        expect(@nil.next_competitor).to eq(@prev)
      end
    end
  end

  describe "#previous_competitor" do
    before do
      @series = FactoryGirl.create(:series)
      @c = FactoryGirl.create(:competitor, :series => @series, :number => 15)
      FactoryGirl.create(:competitor) # another series
    end

    it "should return itself when no other competitors" do
      expect(@c.previous_competitor).to eq(@c)
    end

    context "other competitors" do
      before do
        @first = FactoryGirl.create(:competitor, :series => @series, :number => 10)
        @nil = FactoryGirl.create(:competitor, :series => @series, :number => nil)
        @prev = FactoryGirl.create(:competitor, :series => @series, :number => 12)
        @next = FactoryGirl.create(:competitor, :series => @series, :number => 17)
        @last = FactoryGirl.create(:competitor, :series => @series, :number => 20)
        @series.reload
      end

      it "should return the competitor with next smallest number when such exists" do
        expect(@c.previous_competitor).to eq(@prev)
      end

      it "should return the competitor with biggest number when no smaller numbers" do
        expect(@first.previous_competitor).to eq(@last)
      end

      it "should return the previous by id if competitor has no number" do
        expect(@nil.previous_competitor).to eq(@first)
      end
    end
  end

  describe "#finished?" do
    context "when competitor has some 'no result reason'" do
      it "should return true" do
        c = FactoryGirl.build(:competitor, :no_result_reason => Competitor::DNS)
        expect(c).to be_finished
      end
    end

    context "when competitor has no 'no result reason'" do
      before do
        # no need to have correct estimate
        series = FactoryGirl.build(:series)
        @competitor = FactoryGirl.build(:competitor, :no_result_reason => nil,
          :series => series)
        @competitor.start_time = '11:10'
        @competitor.arrival_time = '11:20'
        @competitor.shots_total_input = 90
        @competitor.estimate1 = 100
        @competitor.estimate2 = 110
      end

      context "when competitor has shots and arrival time" do
        context "when competitor has both estimates" do
          it "should return true" do
            expect(@competitor).to be_finished
          end
        end

        context "when either estimate is missing" do
          it "should return false" do
            @competitor.estimate2 = nil
            expect(@competitor).not_to be_finished
            @competitor.estimate1 = nil
            @competitor.estimate2 = 110
            expect(@competitor).not_to be_finished
          end
        end

        context "when 4 estimates for the series" do
          before do
            @competitor.series.estimates = 4
          end

          context "when 3rd estimate is missing" do
            it "should return false" do
              @competitor.estimate3 = nil
              @competitor.estimate4 = 110
              expect(@competitor).not_to be_finished
            end
          end

          context "when 4th estimate is missing" do
            it "should return false" do
              @competitor.estimate3 = 110
              @competitor.estimate4 = nil
              expect(@competitor).not_to be_finished
            end
          end
        end
      end

      context "when shots result is missing" do
        it "should return false" do
          @competitor.shots_total_input = nil
          expect(@competitor).not_to be_finished
        end
      end

      context "when time result is missing" do
        it "should return false" do
          @competitor.arrival_time = nil
          expect(@competitor).not_to be_finished
        end
      end

      context "when series does not calculate time points and other results are there" do
        it "should return true" do
          @competitor.series.time_points_type = Series::TIME_POINTS_TYPE_NONE
          @competitor.arrival_time = nil
          expect(@competitor).to be_finished
        end
      end

      context "when series gives 300 time points for all and other results are there" do
        it "should return true" do
          @competitor.series.time_points_type = Series::TIME_POINTS_TYPE_ALL_300
          @competitor.arrival_time = nil
          expect(@competitor).to be_finished
        end
      end
    end
  end

  describe "#comparison_time_in_seconds" do
    it "should delegate call to series with own age group and all_competitors as parameters" do
      all_competitors = true
      series = instance_double(Series)
      age_group = instance_double(AgeGroup)
      competitor = FactoryGirl.build(:competitor, :series => series, :age_group => age_group)
      expect(series).to receive(:comparison_time_in_seconds).with(age_group, all_competitors).and_return(12345)
      expect(competitor.comparison_time_in_seconds(all_competitors)).to eq(12345)
    end
  end

  describe "#reset_correct_estimates" do
    it "should set all correct estimates to nil" do
      c = FactoryGirl.build(:competitor, :correct_estimate1 => 100,
        :correct_estimate2 => 110, :correct_estimate3 => 130,
        :correct_estimate4 => 140)
      c.reset_correct_estimates
      expect(c.correct_estimate1).to be_nil
      expect(c.correct_estimate2).to be_nil
      expect(c.correct_estimate3).to be_nil
      expect(c.correct_estimate4).to be_nil
    end
  end

  describe "#free_offline_competitors_left" do
    context "when online state" do
      it "should raise error" do
        allow(Mode).to receive(:online?).and_return(true)
        allow(Mode).to receive(:offline?).and_return(false)
        expect { Competitor.free_offline_competitors_left }.to raise_error
      end
    end

    context "when offline state" do
      before do
        allow(Mode).to receive(:online?).and_return(false)
        allow(Mode).to receive(:offline?).and_return(true)
      end

      it "should return full amount initially" do
        expect(Competitor.free_offline_competitors_left).to eq(
          Competitor::MAX_FREE_COMPETITOR_AMOUNT_IN_OFFLINE
        )
      end

      it "should recude added competitors from the full amount" do
        FactoryGirl.create(:competitor)
        FactoryGirl.create(:competitor)
        expect(Competitor.free_offline_competitors_left).to eq(
          Competitor::MAX_FREE_COMPETITOR_AMOUNT_IN_OFFLINE - 2
        )
      end

      it "should be zero when would actually be negative (for some reason)" do
        allow(Competitor).to receive(:count).and_return(Competitor::MAX_FREE_COMPETITOR_AMOUNT_IN_OFFLINE + 1)
        expect(Competitor.free_offline_competitors_left).to eq(0)
      end
    end
  end

  describe "create with number" do
    before do
      @race = FactoryGirl.create(:race)
      series = FactoryGirl.create(:series, :race => @race)
      @competitor = FactoryGirl.build(:competitor, :series => series, :number => 10)
    end

    context "when no correct estimates defined for this number" do
      it "should leave correct estimates as nil" do
        @competitor.save!
        verify_correct_estimates nil, nil, nil, nil
      end
    end

    context "when correct estimates defined for this number" do
      before do
        @race.correct_estimates << FactoryGirl.build(:correct_estimate, :race => @race,
          :min_number => 9, :distance1 => 101, :distance2 => 102,
          :distance3 => 103, :distance4 => 104)
      end

      it "should set the correct estimates for the competitor" do
        @competitor.number = 11
        @competitor.save!
        verify_correct_estimates 101, 102, 103, 104
      end
    end

    def verify_correct_estimates(ce1, ce2, ce3, ce4)
      @competitor.reload
      expect(@competitor.correct_estimate1).to eq(ce1)
      expect(@competitor.correct_estimate2).to eq(ce2)
      expect(@competitor.correct_estimate3).to eq(ce3)
      expect(@competitor.correct_estimate4).to eq(ce4)
    end
  end
  
  describe "#relative_points" do
    before do
      @all_competitors = false
    end

    it "should be -3 when competitor was disqualified" do
      expect(FactoryGirl.build(:competitor, :no_result_reason => Competitor::DQ).relative_points(@all_competitors)).to eq(-3)
    end
    
    it "should be -2 when competitor did not start" do
      expect(FactoryGirl.build(:competitor, :no_result_reason => Competitor::DNS).relative_points(@all_competitors)).to eq(-2)
    end
    
    it "should be -1 when competitor did not finish" do
      expect(FactoryGirl.build(:competitor, :no_result_reason => Competitor::DNF).relative_points(@all_competitors)).to eq(-1)
    end
    
    it "should be 0 when competitor has no results yet" do
      expect(FactoryGirl.build(:competitor).relative_points(@all_competitors)).to eq(0)
    end
    
    it "should be 10000 x points + 1000 x partial points + 100 x shot points + 10 x time points + negative time" do
      c = FactoryGirl.build(:competitor)
      allow(c).to receive(:points).with(@all_competitors).and_return(800)
      allow(c).to receive(:points!).with(@all_competitors).and_return(500)
      allow(c).to receive(:shot_points).and_return(300)
      allow(c).to receive(:time_points).with(@all_competitors).and_return(250)
      allow(c).to receive(:time_in_seconds).and_return(3000)
      expect(c.relative_points(@all_competitors)).to eq(10000*800 + 1000*500 + 100*300 + 10*250 - 3000)
    end
  end

  describe "#start_datetime" do
    it "should return value from StartDateTime module" do
      race = instance_double(Race)
      series = FactoryGirl.build(:series, race: race, start_day: 2)
      competitor = FactoryGirl.build(:competitor, series: series)
      expect(competitor).to receive(:start_date_time).with(race, 2, competitor.start_time).and_return('time')
      expect(competitor.start_datetime).to eq('time')
    end
  end
end
