require 'spec_helper'

describe RelayEstimateQuickSave do
  before do
    @race = FactoryGirl.create(:race)
    @relay = FactoryGirl.create(:relay, :race => @race, :legs_count => 2)
    @team = FactoryGirl.create(:relay_team, :relay => @relay, :number => 5)
    @c = FactoryGirl.create(:relay_competitor, :relay_team => @team, :leg => 2)
  end

  it "should save the estimate when competitor found and valid estimate" do
    @qs = RelayEstimateQuickSave.new(@relay.id, '5,2,105')
    check_success 105
  end

  it "should handle error when invalid estimate" do
    @qs = RelayEstimateQuickSave.new(@relay.id, '5,2,0')
    check_failure true
  end

  it "should handle error when unknown leg number" do
    @qs = RelayEstimateQuickSave.new(@relay.id, '5,3,105')
    check_failure
  end

  it "should handle error when unknown team number" do
    @qs = RelayEstimateQuickSave.new(@relay.id, '4,2,105')
    check_failure
  end

  it "should handle error when invalid string format" do
    @qs = RelayEstimateQuickSave.new(@relay.id, '5,2.105')
    check_failure
  end
  
  context "when data already stored" do
    before do
      @c.estimate = 99
      @c.save!
    end
    
    it "should handle error when normal input" do
      @qs = RelayEstimateQuickSave.new(@relay.id, '5,2,100')
      check_failure true, 99
    end
    
    it "should override when input starts with ++" do
      @qs = RelayEstimateQuickSave.new(@relay.id, '++5,2,100')
      check_success 100
    end
  end
  
  def check_success(estimate)
    saved = @qs.save
    raise @qs.error unless saved
    @qs.competitor.should == @c
    @qs.error.should be_nil
    @c.reload
    @c.estimate.should == estimate
  end

  def check_failure(competitor=false, estimate=nil)
    @qs.save.should be_false
    @qs.error.should_not be_nil
    @qs.competitor.should == @c if competitor
    @qs.competitor.should be_nil unless competitor
    @c.reload
    @c.estimate.should == estimate
  end
end

