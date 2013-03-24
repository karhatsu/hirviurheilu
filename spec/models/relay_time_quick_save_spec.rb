require 'spec_helper'

describe RelayTimeQuickSave do
  before do
    @race = FactoryGirl.create(:race)
    @relay = FactoryGirl.create(:relay, :race => @race, :legs_count => 2,
      :start_time => '11:00')
    @team = FactoryGirl.create(:relay_team, :relay => @relay, :number => 5)
    @c = FactoryGirl.create(:relay_competitor, :relay_team => @team, :leg => 1)
  end

  it "should save the arrival time when competitor found and valid arrival time" do
    @qs = RelayTimeQuickSave.new(@relay.id, '5,1,112059')
    check_success '11:20:59'
  end

  it "should handle error when invalid arrival time" do
    @qs = RelayTimeQuickSave.new(@relay.id, '5,1,105959')
    check_failure true
  end

  it "should handle error when unknown leg number" do
    @qs = RelayTimeQuickSave.new(@relay.id, '5,2,112059')
    check_failure
  end

  it "should handle error when unknown team number" do
    @qs = RelayTimeQuickSave.new(@relay.id, '4,1,112059')
    check_failure
  end

  it "should handle error when invalid string format" do
    @qs = RelayTimeQuickSave.new(@relay.id, '5,1,112060')
    check_failure
  end

  context "when data already stored" do
    before do
      @c.arrival_time = '11:25:12'
      @c.save!
    end
    
    it "should handle error when normal input" do
      @qs = RelayTimeQuickSave.new(@relay.id, '5,1,112513')
      check_failure true, '11:25:12'
    end
    
    it "should override when input starts with ++" do
      @qs = RelayTimeQuickSave.new(@relay.id, '++5,1,112513')
      check_success '11:25:13'
    end
  end
  
  def check_success(arrival_time)
    saved = @qs.save
    raise @qs.error unless saved
    @qs.competitor.should == @c
    @qs.error.should be_nil
    @c.reload
    @c.arrival_time.strftime('%H:%M:%S').should == arrival_time
  end

  def check_failure(competitor=false, arrival_time=nil)
    @qs.save.should be_false
    @qs.error.should_not be_nil
    @qs.competitor.should == @c if competitor
    @qs.competitor.should be_nil unless competitor
    @c.reload
    if arrival_time
      @c.arrival_time.strftime('%H:%M:%S').should == arrival_time
    else
      @c.arrival_time.should be_nil
    end
  end
end

