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
  end

  describe "best_time_in_seconds" do
    before do
      @series = Factory.build(:series)
      @c1 = mock_model(Competitor, :time_in_seconds => nil)
      @c2 = mock_model(Competitor, :time_in_seconds => 342)
      @c3 = mock_model(Competitor, :time_in_seconds => 341)
      @c4 = mock_model(Competitor, :time_in_seconds => 343)
    end

    it "should return nil if no competitors" do
      @series.should_receive(:competitors).and_return([])
      @series.best_time_in_seconds.should be_nil
    end

    it "should return nil if no competitors with time" do
      @series.should_receive(:competitors).and_return([@c1])
      @series.best_time_in_seconds.should be_nil
    end

    it "should return the time of the competitor who was the fastest" do
      @series.should_receive(:competitors).and_return([@c1, @c2, @c3, @c4])
      @series.best_time_in_seconds.should == 341
    end
  end

  describe "ordered_competitors" do
    before do
      @series = Factory.build(:series)
      @c_nil1 = mock_model(Competitor, :points => nil, :points! => 12)
      @c_nil2 = mock_model(Competitor, :points => nil, :points! => nil)
      @c_nil3 = mock_model(Competitor, :points => nil, :points! => 88)
      @c1 = mock_model(Competitor, :points => 200, :points! => 200)
      @c2 = mock_model(Competitor, :points => 201, :points! => 201)
      @c3 = mock_model(Competitor, :points => 199, :points! => 199)
    end

    it "should return empty list when no competitors defined" do
      @series.should_receive(:competitors).and_return([])
      @series.ordered_competitors.should == []
    end

    it "should return competitors ordered by points desc" do
      @series.should_receive(:competitors).and_return([@c1, @c2, @c3])
      @series.ordered_competitors.should == [@c2, @c1, @c3]
    end

    it "should leave nil points to the bottom" do
      @series.should_receive(:competitors).and_return([@c_nil1, @c1, @c2, @c3])
      @series.ordered_competitors.should == [@c2, @c1, @c3, @c_nil1]
    end

    it "should sort nil points using partial points" do
      @series.should_receive(:competitors).and_return([@c_nil1, @c_nil2,
          @c_nil3, @c1, @c2, @c3])
      @series.ordered_competitors.should == [@c2, @c1, @c3, @c_nil3, @c_nil1, @c_nil2]
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
end
