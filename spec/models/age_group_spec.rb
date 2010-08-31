require 'spec_helper'

describe AgeGroup do
  it "should create age_group with valid attrs" do
    Factory.create(:age_group)
  end

  describe "validation" do
    it "should require name" do
      Factory.build(:age_group, :name => nil).should have(1).errors_on(:name)
    end

    describe "min_competitors" do
      it "should change nil to 0" do
        ag = Factory.create(:age_group, :min_competitors => nil)
        ag.min_competitors.should == 0
      end

      it "should require number" do
        Factory.build(:age_group, :min_competitors => 'xxx').
          should have(1).errors_on(:min_competitors)
      end

      it "should require integer" do
        Factory.build(:age_group, :min_competitors => 1.1).
          should have(1).errors_on(:min_competitors)
      end

      it "should require non-negative number" do
        Factory.build(:age_group, :min_competitors => -1).
          should have(1).errors_on(:min_competitors)
      end
    end
  end

  describe "best_time_in_seconds" do
    before do
      @age_group = Factory.create(:age_group)
      @c1 = Factory.build(:competitor, :age_group => @age_group)
      @c2 = Factory.build(:competitor, :age_group => @age_group)
      @age_group.competitors << @c1
      @age_group.competitors << @c2
    end

    it "should call static method in Series" do
      Series.should_receive(:best_time_in_seconds).with([@c1, @c2]).and_return(123)
      @age_group.best_time_in_seconds.should == 123
    end

    describe "cache" do
      it "should calculate in the first time and get from cache in the second" do
        Series.should_receive(:best_time_in_seconds).with([@c1, @c2]).once.and_return(148)
        @age_group.best_time_in_seconds.should == 148
        @age_group.best_time_in_seconds.should == 148
      end
    end
  end

  describe "#has_enough_competitors?" do
    before do
      @age_group = Factory.create(:age_group, :min_competitors => 2)
      @age_group.competitors << Factory.build(:competitor, :age_group => @age_group)
    end

    context "when competitor count is less than the min limit" do
      it "should return false" do
        @age_group.should_not have_enough_competitors
      end
    end

    context "when competitor count is at least the same as the min limit" do
      it "should return true" do
        @age_group.competitors << Factory.build(:competitor, :age_group => @age_group)
        @age_group.should have_enough_competitors
      end
    end
  end
end
