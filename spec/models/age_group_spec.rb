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
      @age_group = Factory.create(:age_group, :min_competitors => 2)
      @c1 = Factory.build(:competitor, :age_group => @age_group)
      @c2 = Factory.build(:competitor, :age_group => @age_group)
      @age_group.competitors << @c1
      @age_group.competitors << @c2
    end

    context "when enough competitors" do
      it "should call static method in Series" do
        Series.should_receive(:best_time_in_seconds).with(@age_group, false).and_return(123)
        @age_group.best_time_in_seconds(false).should == 123
      end

      context "in all competitors case" do
        it "should call static method in Series" do
          @age_group.competitors << Factory.build(:competitor, :age_group => @age_group,
            :unofficial => true)
          @age_group.min_competitors = 3
          Series.should_receive(:best_time_in_seconds).with(@age_group, true).and_return(100)
          @age_group.best_time_in_seconds(true).should == 100
        end
      end
    end

    context "when not enough competitors" do
      it "should return nil" do
        @c1.destroy
        @age_group.reload
        Series.should_not_receive(:best_time_in_seconds)
        @age_group.best_time_in_seconds.should be_nil
      end
    end

    describe "cache" do
      it "should calculate in the first time and get from (correct) cache in the second" do
        Series.should_receive(:best_time_in_seconds).with(@age_group, false).once.and_return(148)
        Series.should_receive(:best_time_in_seconds).with(@age_group, true).once.and_return(100)
        @age_group.best_time_in_seconds(false).should == 148
        @age_group.best_time_in_seconds(true).should == 100
        @age_group.best_time_in_seconds(false).should == 148
        @age_group.best_time_in_seconds(true).should == 100
      end
    end
  end

  describe "#has_enough_competitors?" do
    before do
      @age_group = Factory.create(:age_group, :min_competitors => 2)
      @age_group.competitors << Factory.build(:competitor, :age_group => @age_group)
      @age_group.competitors << Factory.build(:competitor, :age_group => @age_group,
        :no_result_reason => Competitor::DNS)
      @age_group.competitors << Factory.build(:competitor, :age_group => @age_group,
        :no_result_reason => Competitor::DNF)
    end

    context "when competitor count (excl. DNS/DNF) is less than the min limit" do
      it "should return false" do
        @age_group.should_not have_enough_competitors
      end
    end

    context "when competitor count (excl. DNS/DNF) is at least the same as the min limit" do
      it "should return true" do
        @age_group.competitors << Factory.build(:competitor, :age_group => @age_group)
        @age_group.should have_enough_competitors
      end
    end

    describe "with all competitors" do
      before do
        @age_group.competitors << Factory.build(:competitor, :age_group => @age_group,
          :unofficial => true)
      end

      it "should not calculate the unofficial competitors" do
        @age_group.should_not have_enough_competitors
      end

      it "should calculate all competitors if asked so" do
        @age_group.has_enough_competitors?(true).should be_true
      end
    end
  end
end
