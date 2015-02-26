require 'spec_helper'

describe RelayMissesQuickSave do
  before do
    @race = create(:race)
    @relay = create(:relay, :race => @race, :legs_count => 2)
    @team = create(:relay_team, :relay => @relay, :number => 5)
    @c = create(:relay_competitor, :relay_team => @team, :leg => 2)
  end

  it "should save the misses when competitor found and valid misses" do
    @qs = RelayMissesQuickSave.new(@relay.id, '5,2,1')
    check_success 1
  end

  it "should handle error when invalid misses" do
    @qs = RelayMissesQuickSave.new(@relay.id, '5,2,6')
    check_failure true
  end

  it "should handle error when unknown leg number" do
    @qs = RelayMissesQuickSave.new(@relay.id, '5,1,1')
    check_failure
  end

  it "should handle error when unknown team number" do
    @qs = RelayMissesQuickSave.new(@relay.id, '4,2,1')
    check_failure
  end

  it "should handle error when invalid string format" do
    @qs = RelayMissesQuickSave.new(@relay.id, '5,x2,1')
    check_failure
  end
  
  context "when data already stored" do
    before do
      @c.misses = 2
      @c.save!
    end
    
    it "should handle error when normal input" do
      @qs = RelayMissesQuickSave.new(@relay.id, '5,2,1')
      check_failure true, 2
    end
    
    it "should override when input starts with ++" do
      @qs = RelayMissesQuickSave.new(@relay.id, '++5,2,3')
      check_success 3
    end
  end
  
  def check_success(misses)
    saved = @qs.save
    raise @qs.error unless saved
    expect(@qs.competitor).to eq(@c)
    expect(@qs.error).to be_nil
    @c.reload
    expect(@c.misses).to eq(misses)
  end

  def check_failure(competitor=false, misses=nil)
    expect(@qs.save).to be_falsey
    expect(@qs.error).not_to be_nil
    expect(@qs.competitor).to eq(@c) if competitor
    expect(@qs.competitor).to be_nil unless competitor
    @c.reload
    expect(@c.misses).to eq(misses)
  end
end

