require 'spec_helper'

describe RelayEstimateQuickSave do
  before do
    @race = create(:race)
    @relay = create(:relay, :race => @race, :legs_count => 2)
    @team = create(:relay_team, :relay => @relay, :number => 5, name: 'Pohjanmaa')
    @c = create(:relay_competitor, :relay_team => @team, :leg => 2, first_name: 'Mikko', last_name: 'Miettinen')
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
      expect(@qs.error).to eq('Kilpailijalle (Mikko Miettinen, Pohjanmaa) on jo talletettu tieto. Voit ylikirjoittaa vanhan tuloksen syöttämällä ++joukkue,osuus,tulos.')
    end
    
    it "should override when input starts with ++" do
      @qs = RelayEstimateQuickSave.new(@relay.id, '++5,2,100')
      check_success 100
    end
  end
  
  def check_success(estimate)
    saved = @qs.save
    raise @qs.error unless saved
    expect(@qs.competitor).to eq(@c)
    expect(@qs.error).to be_nil
    @c.reload
    expect(@c.estimate).to eq(estimate)
  end

  def check_failure(competitor=false, estimate=nil)
    expect(@qs.save).to be_falsey
    expect(@qs.error).not_to be_nil
    expect(@qs.competitor).to eq(@c) if competitor
    expect(@qs.competitor).to be_nil unless competitor
    @c.reload
    expect(@c.estimate).to eq(estimate)
  end
end

