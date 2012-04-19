require 'spec_helper'

describe RelayTimeQuickSave do
  before do
    @race = FactoryGirl.create(:race)
    @relay = FactoryGirl.create(:relay, :race => @race, :legs_count => 2,
      :start_time => '11:00')
    @team = FactoryGirl.create(:relay_team, :relay => @relay, :number => 5)
    @c = FactoryGirl.create(:relay_competitor, :relay_team => @team, :leg => 1,
      :arrival_time => '11:25:12')
  end

  it "should save the arrival time when competitor found and valid arrival time" do
    @qs = RelayTimeQuickSave.new(@relay.id, '5,1,112059')
    @qs.save.should be_true
    @qs.competitor.should == @c
    @qs.error.should be_nil
    @c.reload
    @c.arrival_time.strftime('%H:%M:%S').should == '11:20:59'
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

  def check_failure(competitor=false)
    @qs.save.should be_false
    @qs.error.should_not be_nil
    @qs.competitor.should == @c if competitor
    @qs.competitor.should be_nil unless competitor
    @c.reload
    @c.arrival_time.strftime('%H:%M:%S').should == '11:25:12'
  end
end

