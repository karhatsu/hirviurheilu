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
  
  describe "#competitors_count" do
    before do
      series = Factory.create(:series)
      @age_group = Factory.build(:age_group, :series => series)
      series.age_groups << @age_group
      series.competitors << Factory.build(:competitor, :series => series, :age_group => @age_group)
      series.competitors << Factory.build(:competitor, :series => series, :age_group => @age_group)
      series.competitors << Factory.build(:competitor, :series => series)
      series.competitors << Factory.build(:competitor, :series => series, :age_group => @age_group,
        :no_result_reason => 'DNS')
      series.competitors << Factory.build(:competitor, :series => series, :age_group => @age_group,
        :unofficial => true)
    end
    
    context "when all competitors" do
      it "should count all competitors for the age group that have no no_result_reason" do
        @age_group.competitors_count(true).should == 3
      end
    end
    
    context "when only official competitors" do
      it "should count all official competitors for the age group that have no no_result_reason" do
        @age_group.competitors_count(false).should == 2
      end
    end
  end

end
