require 'spec_helper'

describe RelayAdjustmentQuickSave do
  before do
    @race = FactoryGirl.create(:race)
    @relay = FactoryGirl.create(:relay, :race => @race, :legs_count => 2)
    @team = FactoryGirl.create(:relay_team, :relay => @relay, :number => 5)
    @c = FactoryGirl.create(:relay_competitor, :relay_team => @team, :leg => 2,
      :adjustment => 99)
  end

  it "should save the adjustment when competitor found and valid adjustment" do
    @qs = RelayAdjustmentQuickSave.new(@relay.id, '5,2,105')
    @qs.save.should be_true
    @qs.competitor.should == @c
    @qs.error.should be_nil
    @c.reload
    @c.adjustment.should == 105
  end

  it "should save the adjustment when competitor found and valid negative adjustment" do
    @qs = RelayAdjustmentQuickSave.new(@relay.id, '5,2,-125')
    @qs.save.should be_true
    @qs.competitor.should == @c
    @qs.error.should be_nil
    @c.reload
    @c.adjustment.should == -125
  end

  it "should handle error when invalid adjustment" do
    @qs = RelayAdjustmentQuickSave.new(@relay.id, '5,2,1.1')
    check_failure
  end

  it "should handle error when unknown leg number" do
    @qs = RelayAdjustmentQuickSave.new(@relay.id, '5,1,105')
    check_failure
  end

  it "should handle error when unknown team number" do
    @qs = RelayAdjustmentQuickSave.new(@relay.id, '4,2,105')
    check_failure
  end

  it "should handle error when invalid string format" do
    @qs = RelayAdjustmentQuickSave.new(@relay.id, '5,2.105')
    check_failure
  end

  def check_failure(competitor=false)
    @qs.save.should be_false
    @qs.error.should_not be_nil
    @qs.competitor.should == @c if competitor
    @qs.competitor.should be_nil unless competitor
    @c.reload
    @c.adjustment.should == 99
  end
end

