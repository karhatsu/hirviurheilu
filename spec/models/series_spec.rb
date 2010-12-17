require 'spec_helper'

describe Series do
  describe "create" do
    it "should create series with valid attrs" do
      Factory.create(:series)
    end
  end

  describe "validation" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:race) }

    describe "start time" do
      before do
        @race = Factory.create(:race, :start_date => Date.today + 3,
          :end_date => Date.today + 4)
      end

      it { should allow_value(nil).for(:start_time) }

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
      it { should validate_numericality_of(:first_number) }
      it { should allow_value(nil).for(:first_number) }
      it { should_not allow_value(23.5).for(:first_number) }
      it { should_not allow_value(0).for(:first_number) }
      it { should allow_value(1).for(:first_number) }
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
    end

    describe "static" do
      it "should return nil if no competitors" do
        Series.best_time_in_seconds([]).should be_nil
      end

      it "should return nil if no competitors with time" do
        Series.best_time_in_seconds([@c1]).should be_nil
      end

      it "should return the time of the competitor who was the fastest and skip unfinished" do
        Series.best_time_in_seconds([@c1, @c2, @c3, @c4, @c5]).should == 341
      end
    end

    describe "dynamic" do
      before do
        @series = Factory.create(:series)
        @c1 = Factory.build(:competitor, :series => @series)
        @c2 = Factory.build(:competitor, :series => @series)
        @series.competitors << @c1
        @series.competitors << @c2
      end

      it "should call static method" do
        Series.should_receive(:best_time_in_seconds).with([@c1, @c2]).and_return(123)
        @series.best_time_in_seconds.should == 123
      end

      describe "cache" do
        it "should calculate in the first time and get from cache in the second" do
          Series.should_receive(:best_time_in_seconds).with([@c1, @c2]).once.and_return(148)
          @series.best_time_in_seconds.should == 148
          @series.best_time_in_seconds.should == 148
        end
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

  describe "#next_start_time" do
    context "when no competitors" do
      it "should be nil when start_time is nil" do
        series = Factory.build(:series, :start_time => nil)
        series.next_start_time.should be_nil
      end

      it "should be start_time when it is defined" do
        series = Factory.build(:series, :start_time => '12:30')
        series.next_start_time.should == series.start_time
      end
    end

    context "when competitors" do
      it "should be the start time of the latest competitor + race time interval" do
        race = Factory.create(:race, :start_interval_seconds => 45)
        series = Factory.create(:series, :race => race)
        series.competitors << Factory.build(:competitor, :number => 15, :series => series)
        series.competitors << Factory.build(:competitor, :number => 24, :series => series,
          :start_time => '12:30:00')
        series.competitors << Factory.build(:competitor, :number => 17, :series => series)
        series.next_start_time.strftime('%H:%M:%S').should == '12:30:45'
      end

      it "should be like no competitors when competitors have no start times yet" do
        race = Factory.create(:race, :start_date => '2010-11-10')
        series = Factory.create(:series, :race => race, :start_time => '2010-11-10 09:30')
        series.competitors << Factory.build(:competitor, :start_time => nil, :series => series)
        series.competitors << Factory.build(:competitor, :start_time => nil, :series => series)
        series.next_start_time.strftime('%H:%M:%S').should == '09:30:00'
      end
    end
  end

  describe "#generate_numbers" do
    before do
      @race = Factory.create(:race)
      @series = Factory.create(:series, :race => @race, :first_number => 5)
      @old1, @old2, @old3 = nil, 9, 13
      @c1 = Factory.create(:competitor, :series => @series, :number => @old1)
      @c2 = Factory.create(:competitor, :series => @series, :number => @old2)
      @c3 = Factory.create(:competitor, :series => @series, :number => @old3)
    end
    
    describe "generation fails" do
      context "some competitor already has arrival time" do
        it "should do nothing for competitors, add error and return false" do
          @c4 = Factory.create(:competitor, :series => @series,
            :start_time => '14:00', :arrival_time => '14:30', :number => 5)
          @series.reload
          @series.generate_numbers(Series::START_LIST_ADDING_ORDER).should be_false
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
          @series.generate_numbers(Series::START_LIST_ADDING_ORDER).should be_false
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
      describe "adding order" do
        it "should generate numbers based on series first number and return true" do
          @series.generate_numbers(Series::START_LIST_ADDING_ORDER).should be_true
          @series.should be_valid
          @c1.reload
          @c2.reload
          @c3.reload
          @c1.number.should == 5
          @c2.number.should == 6
          @c3.number.should == 7
        end
      end

      describe "random order" do
        it "should generate numbers based on series first number and return true" do
          @series.generate_numbers(Series::START_LIST_RANDOM).should be_true
          @series.should be_valid
          @c1.reload
          @c2.reload
          @c3.reload
          [5,6,7].should include(@c1.number)
          [5,6,7].should include(@c2.number)
          [5,6,7].should include(@c3.number)
          i = 0
          while @c1.number == 5 do
            @series.generate_numbers(Series::START_LIST_RANDOM)
            i += 1
            if i > 10
              fail "Random order not working"
            end
          end
        end
      end
    end
  end

  describe "#generate_numbers!" do
    before do
      @series = Factory.build(:series)
    end

    it "should return true when generation succeeds" do
      @series.should_receive(:generate_numbers).with(0).and_return(true)
      @series.generate_numbers!(0).should be_true
    end

    it "raise exception if generation fails" do
      @series.should_receive(:generate_numbers).with(0).and_return(false)
      lambda { @series.generate_numbers!(0) }.should raise_error
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
            :start_time => '14:00', :arrival_time => '14:30', :number => 5)
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

  describe "#generate_start_times!" do
    before do
      @series = Factory.build(:series)
    end
    
    it "should return true when generation succeeds" do
      @series.should_receive(:generate_start_times).and_return(true)
      @series.generate_start_times!.should be_true
    end
    
    it "raise exception if generation fails" do
      @series.should_receive(:generate_start_times).and_return(false)
      lambda { @series.generate_start_times! }.should raise_error
    end
  end

  describe "#generate_start_list" do
    before do
      @series = Factory.create(:series)
    end

    context "when generation succeeds" do
      it "should call generate_numbers and generate_start_times" do
        @series.should_receive(:generate_numbers).with(0).and_return(true)
        @series.should_receive(:generate_start_times).and_return(true)
        @series.generate_start_list(0).should be_true
        @series.reload
        @series.should have_start_list
      end
    end

    context "when number generation fails" do
      it "should not generate start times, should return false and have no start list" do
        @series.should_receive(:generate_numbers).with(0).and_return(false)
        @series.should_not_receive(:generate_start_times)
        @series.generate_start_list(0).should be_false
        @series.reload
        @series.should_not have_start_list
      end
    end

    context "when start number generation fails" do
      it "should return false and have no start list" do
        @series.should_receive(:generate_numbers).with(0).and_return(true)
        @series.should_receive(:generate_start_times).and_return(false)
        @series.generate_start_list(0).should be_false
        @series.reload
        @series.should_not have_start_list
      end
    end
  end

  describe "#generate_start_list!" do
    before do
      @series = Factory.create(:series)
    end

    context "when generation succeeds" do
      it "should set has_start_list to true and return true" do
        @series.should_receive(:generate_numbers!).with(0)
        @series.should_receive(:generate_start_times!)
        @series.generate_start_list!(0).should be_true
        @series.reload
        @series.should have_start_list
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

  describe "#each_competitor_has_number?" do
    before do
      @series = Factory.create(:series)
      @series.competitors << Factory.build(:competitor, :series => @series,
        :number => 1)
    end

    context "when at least one number is missing" do
      before do
        @series.competitors << Factory.build(:competitor, :series => @series,
          :number => nil)
      end

      specify { @series.each_competitor_has_number?.should be_false }
    end

    context "when no numbers missing" do
      specify { @series.each_competitor_has_number?.should be_true }
    end
  end

  describe "#each_competitor_has_start_time?" do
    before do
      @series = Factory.create(:series)
      @series.competitors << Factory.build(:competitor, :series => @series,
        :start_time => '12:45')
    end

    context "when at least one start_time is missing" do
      before do
        @series.competitors << Factory.build(:competitor, :series => @series,
          :start_time => nil)
      end

      specify { @series.each_competitor_has_start_time?.should be_false }
    end

    context "when no start_times missing" do
      specify { @series.each_competitor_has_start_time?.should be_true }
    end
  end

  describe "#each_competitor_finished?" do
    before do
      @series = Factory.build(:series)
      @c1 = mock_model(Competitor, :finished? => true)
      @c2 = mock_model(Competitor, :finished? => false)
    end

    context "when at least one competitor hasn't finished" do
      before do
        @series.stub!(:competitors).and_return([@c1, @c2])
      end

      specify { @series.each_competitor_finished?.should be_false }
    end

    context "when all competitors have finished" do
      before do
        @series.stub!(:competitors).and_return([@c1])
      end

      specify { @series.each_competitor_finished?.should be_true }
    end
  end

  describe "#finished_competitors_count" do
    before do
      @series = Factory.build(:series)
      @c1, @c2, @c3 = mock(Competitor), mock(Competitor), mock(Competitor)
      @series.stub!(:competitors).and_return([@c1, @c2, @c3])
      @c1.stub!(:finished?).and_return(true)
      @c2.stub!(:finished?).and_return(false)
      @c3.stub!(:finished?).and_return(true)
    end

    it "should return count of competitors who have finished" do
      @series.finished_competitors_count.should == 2
    end
  end

  describe "#ready?" do
    before do
      @series = Factory.build(:series, :has_start_list => true,
        :correct_estimate1 => 111, :correct_estimate2 => 101)
      @series.stub!(:each_competitor_finished?).and_return(true)
    end

    context "when start list not generated" do
      it "should return false" do
        @series.has_start_list = false
        @series.should_not be_ready
      end
    end

    context "when start list generated" do
      context "when correct estimate 1 or 2 missing" do
        it "should return false" do
          @series.correct_estimate1 = nil
          @series.should_not be_ready
          @series.correct_estimate1 = 111
          @series.correct_estimate2 = nil
          @series.should_not be_ready
        end
      end

      context "when correct estimates filled" do
        context "when some competitor has no result" do
          it "should return false" do
            @series.should_receive(:each_competitor_finished?).and_return(false)
            @series.should_not be_ready
          end
        end

        context "when each competitor has a result" do
          it "should return true" do
            @series.should be_ready
          end
        end
      end
    end
  end
end
