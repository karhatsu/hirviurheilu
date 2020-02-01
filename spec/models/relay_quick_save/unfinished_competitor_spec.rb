require 'spec_helper'

describe RelayQuickSave::UnfinishedCompetitor do
  before do
    @race = create(:race)
    @relay = create(:relay, :race => @race, :legs_count => 2)
    @team = create(:relay_team, :relay => @relay, :number => 15)
    @c = create(:relay_competitor, :relay_team => @team, :leg => 2)
  end

  it "should save the adjustment when competitor found and valid adjustment" do
    @qs = RelayQuickSave::UnfinishedCompetitor.new(@relay.id, '15,2,105')
    check_success 105
  end

  it "should save the adjustment when competitor found and valid negative adjustment" do
    @qs = RelayQuickSave::UnfinishedCompetitor.new(@relay.id, '15,2,-125')
    check_success(-125)
  end

  it "should handle error when invalid adjustment" do
    @qs = RelayQuickSave::UnfinishedCompetitor.new(@relay.id, '15,2,1.1')
    check_failure
  end

  it "should handle error when unknown leg number" do
    @qs = RelayQuickSave::UnfinishedCompetitor.new(@relay.id, '15,1,105')
    check_failure
  end

  it "should handle error when unknown team number" do
    @qs = RelayQuickSave::UnfinishedCompetitor.new(@relay.id, '4,2,105')
    check_failure
  end

  it "should handle error when invalid string format" do
    @qs = RelayQuickSave::UnfinishedCompetitor.new(@relay.id, '15,2.105')
    check_failure
  end

  context "when data already stored" do
    before do
      @c.adjustment = 9
      @c.save!
    end

    it "should handle error when normal input" do
      @qs = RelayQuickSave::UnfinishedCompetitor.new(@relay.id, '15,2,13')
      check_failure true, 9
    end

    it "should override when input starts with ++" do
      @qs = RelayQuickSave::UnfinishedCompetitor.new(@relay.id, '++15,2,13')
      check_success 13
    end
  end

  def check_success(adjustment)
    saved = @qs.save
    raise @qs.error unless saved
    expect(@qs.competitor).to eq(@c)
    expect(@qs.error).to be_nil
    @c.reload
    expect(@c.adjustment).to eq(adjustment)
  end

  def check_failure(competitor=false, adjustment=nil)
    expect(@qs.save).to be_falsey
    expect(@qs.error).not_to be_nil
    expect(@qs.competitor).to eq(@c) if competitor
    expect(@qs.competitor).to be_nil unless competitor
    @c.reload
    expect(@c.adjustment).to eq(adjustment)
  end
end

