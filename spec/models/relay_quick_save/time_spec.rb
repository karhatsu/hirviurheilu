require 'spec_helper'

describe RelayQuickSave::Time do
  before do
    @race = create(:race)
    @relay = create(:relay, :race => @race, :legs_count => 2,
      :start_time => '11:00')
    @team = create(:relay_team, :relay => @relay, :number => 5)
    @c = create(:relay_competitor, :relay_team => @team, :leg => 1)
    @c2 = create(:relay_competitor, :relay_team => @team, :leg => 2)
  end

  it "should save the arrival time when competitor found and valid arrival time" do
    @qs = RelayQuickSave::Time.new(@relay.id, '5,1,112059')
    check_success '11:20:59'
  end

  it "should handle error when invalid arrival time" do
    qs = RelayQuickSave::Time.new(@relay.id, '5,1,002059')
    qs.save
    @qs = RelayQuickSave::Time.new(@relay.id, '5,2,002058')
    check_failure @c2
  end

  it "should handle error when unknown leg number" do
    @qs = RelayQuickSave::Time.new(@relay.id, '5,3,112059')
    check_failure
  end

  it "should handle error when unknown team number" do
    @qs = RelayQuickSave::Time.new(@relay.id, '4,1,112059')
    check_failure
  end

  it "should handle error when invalid string format" do
    @qs = RelayQuickSave::Time.new(@relay.id, '5,1,112060')
    check_failure
  end

  context "when data already stored" do
    before do
      @c.arrival_time = '11:25:12'
      @c.save!
    end

    it "should handle error when normal input" do
      @qs = RelayQuickSave::Time.new(@relay.id, '5,1,112513')
      check_failure @c, '11:25:12'
    end

    it "should override when input starts with ++" do
      @qs = RelayQuickSave::Time.new(@relay.id, '++5,1,112513')
      check_success '11:25:13'
    end
  end

  def check_success(arrival_time)
    saved = @qs.save
    raise @qs.error unless saved
    expect(@qs.competitor).to eq(@c)
    expect(@qs.error).to be_nil
    @c.reload
    expect(@c.arrival_time.strftime('%H:%M:%S')).to eq(arrival_time)
  end

  def check_failure(expected_competitor=nil, arrival_time=nil)
    expect(@qs.save).to be_falsey
    expect(@qs.error).not_to be_nil
    if expected_competitor
      expect(@qs.competitor).to eq(expected_competitor)
      expected_competitor.reload
      if arrival_time
        expect(expected_competitor.arrival_time.strftime('%H:%M:%S')).to eq(arrival_time)
      else
        expect(expected_competitor.arrival_time).to be_nil
      end
    else
      expect(@qs.competitor).to be_nil
    end
  end
end

