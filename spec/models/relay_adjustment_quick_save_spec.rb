require 'spec_helper'

describe RelayAdjustmentQuickSave do
  before do
    @race = FactoryGirl.create(:race)
    @relay = FactoryGirl.create(:relay, :race => @race, :legs_count => 2)
    @team = FactoryGirl.create(:relay_team, :relay => @relay, :number => 15)
    @c = FactoryGirl.create(:relay_competitor, :relay_team => @team, :leg => 2)
  end

  it "should save the adjustment when competitor found and valid adjustment" do
    @qs = RelayAdjustmentQuickSave.new(@relay.id, '15,2,105')
    check_success 105
  end

  it "should save the adjustment when competitor found and valid negative adjustment" do
    @qs = RelayAdjustmentQuickSave.new(@relay.id, '15,2,-125')
    check_success(-125)
  end

  it "should handle error when invalid adjustment" do
    @qs = RelayAdjustmentQuickSave.new(@relay.id, '15,2,1.1')
    check_failure
  end

  it "should handle error when unknown leg number" do
    @qs = RelayAdjustmentQuickSave.new(@relay.id, '15,1,105')
    check_failure
  end

  it "should handle error when unknown team number" do
    @qs = RelayAdjustmentQuickSave.new(@relay.id, '4,2,105')
    check_failure
  end

  it "should handle error when invalid string format" do
    @qs = RelayAdjustmentQuickSave.new(@relay.id, '15,2.105')
    check_failure
  end

  context "when data already stored" do
    before do
      @c.adjustment = 9
      @c.save!
    end
    
    it "should handle error when normal input" do
      @qs = RelayAdjustmentQuickSave.new(@relay.id, '15,2,13')
      check_failure true, 9
    end
    
    it "should override when input starts with ++" do
      @qs = RelayAdjustmentQuickSave.new(@relay.id, '++15,2,13')
      check_success 13
    end
  end
  
  def check_success(adjustment)
    saved = @qs.save
    raise @qs.error unless saved
    @qs.competitor.should == @c
    @qs.error.should be_nil
    @c.reload
    @c.adjustment.should == adjustment
  end

  def check_failure(competitor=false, adjustment=nil)
    @qs.save.should be_false
    @qs.error.should_not be_nil
    @qs.competitor.should == @c if competitor
    @qs.competitor.should be_nil unless competitor
    @c.reload
    @c.adjustment.should == adjustment
  end
end

