require 'spec_helper'

describe QuickSave::ExtraShots do
  let(:race) { create :race, sport_key: Sport::ILMALUODIKKO }
  let(:series) { create :series, race: race }
  let(:competitor10_shots) { [9,9,9,9,8,8,8,8,7,6,10,9,8,7,6,5,4,3,2,1] }
  let!(:competitor1) { create :competitor, series: series, number: 1 }
  let!(:competitor10) { create :competitor, series: series, number: 10, shots: competitor10_shots }

  context 'when string format is correct and competitor with final round shots is found' do
    before do
      @qs = QuickSave::ExtraShots.new(race.id, '10,+*')
    end

    it 'saves the extra shots' do
      result = @qs.save
      expect_success result, competitor10, [10, 11]
    end
  end

  context 'when string format is correct and competitor with final round input sum is found' do
    before do
      competitor10.shots = nil
      competitor10.qualification_round_shooting_score_input = 91
      competitor10.final_round_shooting_score_input = 93
      competitor10.save!
      @qs = QuickSave::ExtraShots.new(race.id, '10,+*')
    end

    it 'saves the extra shots' do
      result = @qs.save
      expect_success result, competitor10, [10, 11]
    end
  end

  context 'when no shots yet' do
    before do
      @qs = QuickSave::ExtraShots.new(race.id, '1,+99*876510')
    end

    it 'does not save anything' do
      result = @qs.save
      expect_failure result, /Loppukilpailun tulos puuttuu/, competitor1
    end
  end

  context 'when not all final round shots yet' do
    let(:nineteen_shots) { [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9] }

    before do
      competitor1.update_attribute :shots, nineteen_shots
      @qs = QuickSave::ExtraShots.new(race.id, '1,9')
    end

    it 'does not save anything' do
      result = @qs.save
      expect_failure result, /Loppukilpailun tulos puuttuu/, competitor1, nineteen_shots
    end
  end

  context 'when invalid shot given' do
    before do
      race.update_attribute :sport_key, Sport::ILMAHIRVI
      @qs = QuickSave::ExtraShots.new(race.id, '10,*')
    end

    it 'does not save anything' do
      result = @qs.save
      expect_failure result, /virheellisen numeron/, competitor10, competitor10_shots
    end
  end

  describe "unknown competitor" do
    before do
      @qs = QuickSave::ExtraShots.new(race.id, '8,9999999999')
    end

    it 'does not save anything' do
      result = @qs.save
      expect_failure result, /ei löytynyt/
    end
  end

  describe "invalid string format" do
    before do
      @qs = QuickSave::ExtraShots.new(race.id, '10,9x')
    end

    it 'does not save the given result' do
      result = @qs.save
      expect_failure result, /muoto/
    end
  end

  context 'when string is nil' do
    before do
      @qs = QuickSave::ExtraShots.new(race.id, nil)
    end

    it 'does not save anything' do
      result = @qs.save
      expect_failure result, /muoto/
    end
  end

  describe "when some extra shots already stored" do
    let(:extra_shots) { [10, 10] }

    before do
      competitor10.update_attribute :extra_shots, extra_shots
      @qs = QuickSave::ExtraShots.new(race.id, '10,98')
    end

    it 'appends the shots' do
      result = @qs.save
      expect_success result, competitor10, extra_shots + [9, 8]
    end
  end

  def expect_success(result, competitor, extra_shots)
    expect(result).to be_truthy
    expect(@qs.competitor).to eq(competitor)
    expect(@qs.error).to be_nil
    expect(competitor.reload.extra_shots).to eq extra_shots
  end

  def expect_failure(result, error_regex, competitor = nil, original_shots = nil)
    expect(result).to be_falsey
    expect(@qs.competitor).to eq(competitor)
    expect(@qs.error).to match(error_regex)
    if competitor
      expect(competitor.reload.shots).to eq(original_shots)
    end
  end
end
