require 'spec_helper'

describe Series do
  describe "create" do
    it "should create series with valid attrs" do
      Factory.create(:series)
    end
  end

  describe "validation" do
    it "should require name" do
      Factory.build(:series, :name => nil).should have(1).errors_on(:name)
    end

    it "should require race" do
      Factory.build(:series, :race => nil).should have(1).errors_on(:race)
    end

    describe "start time" do
      before do
        @race = Factory.create(:race, :start_date => Date.today + 3,
          :end_date => Date.today + 4)
      end

      it "can be nil" do
        Factory.build(:series, :start_time => nil).should be_valid
      end

      it "cannot be before race first day" do
        time = @race.start_date.beginning_of_day
        Factory.build(:series, :race => @race, :start_time => time).should be_valid
        Factory.build(:series, :race => @race, :start_time => time - 1).
          should have(1).errors_on(:start_time)
      end

      it "cannot be after race last day" do
        time = @race.end_date.end_of_day
        Factory.build(:series, :race => @race, :start_time => time).should be_valid
        Factory.build(:series, :race => @race, :start_time => time + 1).
          should have(1).errors_on(:start_time)
      end

      it "cannot be after race last day (case end date nil)" do
        race = Factory.create(:race, :start_date => Date.today + 3)
        time = race.start_date.end_of_day
        Factory.build(:series, :race => race, :start_time => time).should be_valid
        Factory.build(:series, :race => race, :start_time => time + 1).
          should have(1).errors_on(:start_time)
      end
    end

    describe "first_number" do
      it "can be nil" do
        Factory.build(:series, :first_number => nil).should be_valid
      end

      it "should be integer, not string" do
        Factory.build(:series, :first_number => 'xyz').
          should have(1).errors_on(:first_number)
      end

      it "should be integer, not decimal" do
        Factory.build(:series, :first_number => 23.5).
          should have(1).errors_on(:first_number)
      end

      it "should be greater than 0" do
        Factory.build(:series, :first_number => 0).
          should have(1).errors_on(:first_number)
      end
    end
  end

  describe "best_time_in_seconds" do
    before do
      @c1 = mock_model(Competitor, :time_in_seconds => nil,
        :no_result_reason => nil)
      @c2 = mock_model(Competitor, :time_in_seconds => 342,
        :no_result_reason => nil)
      @c3 = mock_model(Competitor, :time_in_seconds => 341,
        :no_result_reason => nil)
      @c4 = mock_model(Competitor, :time_in_seconds => 343,
        :no_result_reason => nil)
      @c5 = mock_model(Competitor, :time_in_seconds => 200,
        :no_result_reason => "DNS")
      @c6 = mock_model(Competitor, :time_in_seconds => 200,
        :no_result_reason => "DNS")
      @series = Factory.build(:series)
    end

    it "should return nil if no competitors" do
      @series.should_receive(:competitors).and_return([])
      @series.best_time_in_seconds.should be_nil
    end

    it "should return nil if no competitors with time" do
      @series.should_receive(:competitors).and_return([@c1])
      @series.best_time_in_seconds.should be_nil
    end

    it "should return the time of the competitor who was the fastest and skip unfinished" do
      @series.should_receive(:competitors).and_return([@c1, @c2, @c3, @c4, @c5])
      @series.best_time_in_seconds.should == 341
    end

    describe "cache" do
      before do
        @series = Factory.build(:series)
        @c1 = mock_model(Competitor, :time_in_seconds => 150,
          :no_result_reason => nil)
        @c2 = mock_model(Competitor, :time_in_seconds => 149,
          :no_result_reason => nil)
        @c3 = mock_model(Competitor, :time_in_seconds => 148,
          :no_result_reason => nil)
      end

      it "should calculate in the first time and get from cache in the second" do
        @series.should_receive(:competitors).once.and_return([@c1, @c2, @c3])
        @series.best_time_in_seconds.should == 148
        @series.best_time_in_seconds.should == 148
      end
    end
  end

  describe "ordered_competitors" do
    before do
      @series = Factory.build(:series)
      @c_nil1 = mock_model(Competitor, :points => nil, :points! => 12,
        :no_result_reason => nil, :shot_points => 50, :time_points => 30)
      @c_nil2 = mock_model(Competitor, :points => nil, :points! => nil,
        :no_result_reason => nil, :shot_points => 50, :time_points => nil)
      @c_nil3 = mock_model(Competitor, :points => nil, :points! => 88,
        :no_result_reason => nil, :shot_points => 50, :time_points => 30)
      @c1 = mock_model(Competitor, :points => 199, :points! => 199,
        :no_result_reason => nil, :shot_points => 87, :time_points => 31)
      @c2 = mock_model(Competitor, :points => 201, :points! => 201,
        :no_result_reason => nil, :shot_points => 50, :time_points => 30)
      @c3 = mock_model(Competitor, :points => 199, :points! => 199,
        :no_result_reason => nil, :shot_points => 87, :time_points => 30)
      @c4 = mock_model(Competitor, :points => 199, :points! => 199,
        :no_result_reason => nil, :shot_points => 88, :time_points => 30)
      @c_dnf1 = mock_model(Competitor, :points => 300, :points! => 300,
        :no_result_reason => "DNF", :shot_points => 88, :time_points => 30)
      @c_dnf2 = mock_model(Competitor, :points => 300, :points! => 300,
        :no_result_reason => "DNS", :shot_points => 88, :time_points => 30)
    end

    it "should return empty list when no competitors defined" do
      @series.should_receive(:competitors).and_return([])
      @series.ordered_competitors.should == []
    end

    it "should sort by: 1. DNS/DNF to the bottom, 2. nil points next in the bottom, " +
        "3. points, 4. shot points, 5. time points, 6. partial points" do
      @series.should_receive(:competitors).and_return([@c_nil1, @c_nil2,
          @c_nil3, @c_dnf1, @c_dnf2, @c1, @c2, @c3, @c4])
      @series.ordered_competitors.should == [@c2, @c4, @c1, @c3, @c_nil3, @c_nil1,
        @c_nil2, @c_dnf1, @c_dnf2]
    end
  end

  describe "start_list" do
    it "should return empty array when no competitors" do
      Factory.build(:series).start_list.should == []
    end

    it "should return competitors with start time ordered by start time" do
      series = Factory.create(:series)
      c1 = Factory.build(:competitor, :series => series, :start_time => '15:15')
      c2 = Factory.build(:competitor, :series => series, :start_time => '9:00:00')
      c3 = Factory.build(:competitor, :series => series, :start_time => '9:00:01')
      c4 = Factory.build(:competitor, :series => series, :start_time => nil)
      series.competitors << c1
      series.competitors << c2
      series.competitors << c3
      series.competitors << c4
      series.start_list.should == [c2, c3, c1]
    end
  end

  describe "#next_number" do
    context "no competitors" do
      it "should be 1 when first_number is nil" do
        series = Factory.build(:series, :first_number => nil)
        series.next_number.should == 1
      end

      it "should be first_number when it is defined" do
        series = Factory.build(:series, :first_number => 45)
        series.next_number.should == 45
      end
    end

    context "competitors" do
      it "should the biggest number + 1" do
        series = Factory.create(:series, :first_number => 45)
        series.competitors << Factory.build(:competitor, :number => 15, :series => series)
        series.competitors << Factory.build(:competitor, :number => 24, :series => series)
        series.competitors << Factory.build(:competitor, :number => 17, :series => series)
        series.next_number.should == 25
      end

      it "should be like no competitors when competitors have no numbers yet" do
        series = Factory.create(:series, :first_number => 45)
        series.competitors << Factory.build(:competitor, :number => nil, :series => series)
        series.competitors << Factory.build(:competitor, :number => nil, :series => series)
        series.next_number.should == 45
      end
    end
  end

  describe "#generate_numbers" do
    before do
      @race = Factory.create(:race)
      @series = Factory.create(:series, :race => @race, :first_number => 5)
      @old1, @old2, @old3 = 9, nil, 13
      @c1 = Factory.create(:competitor, :series => @series, :number => @old1)
      @c2 = Factory.create(:competitor, :series => @series, :number => @old2)
      @c3 = Factory.create(:competitor, :series => @series, :number => @old3)
    end
    
    describe "generation fails" do
      context "some competitor already has arrival time" do
        it "should do nothing for competitors, add error and return false" do
          @c4 = Factory.create(:competitor, :series => @series,
            :start_time => '14:00', :arrival_time => '14:30')
          @series.reload
          @series.generate_numbers.should be_false
          @series.should have(1).errors
          check_competitors_no_changes
        end
      end

      context "series has no first number" do
        before do
          @series.first_number = nil
          @series.save!
        end

        it "should do nothing for competitors, add error and return false" do
          @series.reload
          @series.generate_numbers.should be_false
          @series.should have(1).errors
          check_competitors_no_changes
        end
      end
      
      def check_competitors_no_changes
        @c1.reload
        @c1.number.should == @old1
        @c2.reload
        @c2.number.should == @old2
        @c3.reload
        @c3.number.should == @old3
      end
    end

    describe "generation succeeds" do
      it "should generate numbers based on series first number and return true" do
        @series.generate_numbers.should be_true
        @series.should be_valid
        @c1.reload
        @c2.reload
        @c3.reload
        @c1.number.should == 5
        @c2.number.should == 6
        @c3.number.should == 7
      end
    end
  end

  describe "#generate_start_times" do
    before do
      @race = Factory.create(:race, :start_date => '2010-08-15',
        :start_interval_seconds => 30)
      @series = Factory.create(:series, :race => @race,
        :first_number => 9, :start_time => '2010-08-15 10:00:15')
      @c1 = Factory.create(:competitor, :series => @series, :number => 9)
      @c2 = Factory.create(:competitor, :series => @series, :number => 11)
      @c3 = Factory.create(:competitor, :series => @series, :number => 13)
    end

    describe "generation fails" do
      context "time interval hasn't been defined for the race" do
        before do
          @race.start_interval_seconds = nil
          @race.save!
        end

        it "should do nothing for competitors, add error and return false" do
          @series.reload
          @series.generate_start_times.should be_false
          @series.should have(1).errors
          check_competitors_no_changes([@c1, @c2, @c3])
        end
      end

      context "competitors are missing numbers" do
        it "should do nothing for competitors, add error and return false" do
          @c4 = Factory.create(:competitor, :series => @series, :number => nil)
          @series.reload
          @series.generate_start_times.should be_false
          @series.should have(1).errors
          check_competitors_no_changes([@c1, @c2, @c3, @c4])
        end
      end

      context "some competitor already has arrival time" do
        it "should do nothing for competitors, add error and return false" do
          @c4 = Factory.create(:competitor, :series => @series,
            :start_time => '14:00', :arrival_time => '14:30')
          @series.reload
          @series.generate_start_times.should be_false
          @series.should have(1).errors
          check_competitors_no_changes([@c1, @c2, @c3])
        end
      end

      context "series has no first number" do
        before do
          @series.first_number = nil
          @series.save!
        end

        it "should do nothing for competitors, add error and return false" do
          @series.reload
          @series.generate_start_times.should be_false
          @series.should have(1).errors
          check_competitors_no_changes([@c1, @c2, @c3])
        end
      end

      context "series has no start time" do
        before do
          @series.start_time = nil
          @series.save!
        end

        it "should do nothing for competitors, add error and return false" do
          @series.reload
          @series.generate_start_times.should be_false
          @series.should have(1).errors
          check_competitors_no_changes([@c1, @c2, @c3])
        end
      end

      def check_competitors_no_changes(competitors)
        competitors.each do |c|
          c.reload
          c.start_time.should be_nil
        end
      end
    end

    describe "generation succeeds" do
      it "should generate start times based on time interval and numbers and return true" do
        @series.generate_start_times.should be_true
        @series.should be_valid
        @c1.reload
        @c2.reload
        @c3.reload
        @c1.start_time.strftime('%H:%M:%S').should == '10:00:15'
        @c2.start_time.strftime('%H:%M:%S').should == '10:01:15'
        @c3.start_time.strftime('%H:%M:%S').should == '10:02:15'
      end
    end
  end

  describe "#running?" do
    it "should be false when start time not defined yet" do
      series = Factory.build(:series, :start_time => nil)
      series.should_not be_running
    end

    it "should be false when start time in future" do
      series = Factory.build(:series, :start_time => Time.now + 10)
      series.should_not be_running
    end

    it "should be false when race is finished" do
      race = Factory.build(:race, :finished => true)
      series = Factory.build(:series, :start_time => Time.now - 1, :race => race)
      series.should_not be_running
    end

    it "should be true when race isn't finished and start time in past" do
      race = Factory.build(:race, :finished => false)
      series = Factory.build(:series, :start_time => Time.now - 1, :race => race)
      series.should be_running
    end
  end

  describe "#destroy" do
    before do
      @series = Factory.create(:series)
    end

    it "should be prevented if series has competitors" do
      @series.competitors << Factory.build(:competitor, :series => @series)
      @series.destroy
      @series.should have(1).errors
      Series.should be_exist(@series.id)
    end

    it "should destroy series when no competitors" do
      @series.destroy
      Series.should_not be_exist(@series.id)
    end
  end
end
