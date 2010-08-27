require 'spec_helper'

describe SubSeries do
  it "should create sub_series with valid attrs" do
    Factory.create(:sub_series)
  end

  describe "validation" do
    it "should require name" do
      Factory.build(:sub_series, :name => nil).should have(1).errors_on(:name)
    end

    it "should require series" do
      Factory.build(:sub_series, :series => nil).should have(1).errors_on(:series)
    end
  end

  describe "best_time_in_seconds" do
    before do
      @sub_series = Factory.create(:sub_series)
      @c1 = Factory.build(:competitor, :sub_series => @sub_series)
      @c2 = Factory.build(:competitor, :sub_series => @sub_series)
      @sub_series.competitors << @c1
      @sub_series.competitors << @c2
    end

    it "should call static method in Series" do
      Series.should_receive(:best_time_in_seconds).with([@c1, @c2]).and_return(123)
      @sub_series.best_time_in_seconds.should == 123
    end

    describe "cache" do
      it "should calculate in the first time and get from cache in the second" do
        Series.should_receive(:best_time_in_seconds).with([@c1, @c2]).once.and_return(148)
        @sub_series.best_time_in_seconds.should == 148
        @sub_series.best_time_in_seconds.should == 148
      end
    end
  end
end
