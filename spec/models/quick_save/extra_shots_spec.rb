require 'spec_helper'

describe QuickSave::ExtraShots do
  let(:race) { create :race, sport_key: Sport::ILMALUODIKKO }
  let(:series) { create :series, race: race }
  let(:all_20_shots) { [9, 9, 9, 9, 8, 8, 8, 8, 7, 6, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1] }
  let(:competitor_shots) { all_20_shots }
  let!(:competitor) { create :competitor, series: series, number: 10, shots: competitor_shots }

  context 'when competitor with final round shots is found' do
    let(:competitor_shots) { all_20_shots }

    before do
      @qs = QuickSave::ExtraShots.new(race.id, '10,+*')
    end

    it 'saves the extra shots' do
      result = @qs.save
      expect_success result, competitor, [10, 11]
    end
  end

  context 'when competitor with qualification round input sum is found' do
    before do
      competitor.shots = nil
      competitor.qualification_round_shooting_score_input = 91
      competitor.save!
      @qs = QuickSave::ExtraShots.new(race.id, '10,+*')
    end

    it 'saves the extra shots' do
      result = @qs.save
      expect_success result, competitor, [10, 11]
    end
  end

  context 'when competitor with final round input sum is found' do
    before do
      competitor.shots = nil
      competitor.qualification_round_shooting_score_input = 91
      competitor.final_round_shooting_score_input = 93
      competitor.save!
      @qs = QuickSave::ExtraShots.new(race.id, '10,+*')
    end

    it 'saves the extra shots' do
      result = @qs.save
      expect_success result, competitor, [10, 11]
    end
  end

  context 'when no shots yet' do
    let(:competitor_shots) { nil }
    before do
      @qs = QuickSave::ExtraShots.new(race.id, '10,+99*876510')
    end

    it 'does not save anything' do
      result = @qs.save
      expect_failure result, /Alkukilpailun tulos puuttuu/, competitor
    end
  end

  context 'when not all qualification round shots yet' do
    let(:nine_shots) { [1, 2, 3, 4, 5, 6, 7, 8, 9] }
    let(:competitor_shots) { nine_shots }

    before do
      @qs = QuickSave::ExtraShots.new(race.id, '10,9')
    end

    it 'does not save anything' do
      result = @qs.save
      expect_failure result, /Alkukilpailun tulos puuttuu/, competitor, nine_shots
    end
  end

  context 'when all qualification round shots and no final round shots' do
    let(:ten_shots) { [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
    let(:competitor_shots) { ten_shots }

    before do
      @qs = QuickSave::ExtraShots.new(race.id, '10,9')
    end

    it 'saves the extra shots' do
      result = @qs.save
      expect_success result, competitor, [9]
    end
  end

  context 'when not all final round shots yet' do
    let(:nineteen_shots) { [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9] }
    let(:competitor_shots) { nineteen_shots }

    before do
      @qs = QuickSave::ExtraShots.new(race.id, '10,9')
    end

    it 'does not save anything' do
      result = @qs.save
      expect_failure result, /Loppukilpailun tulos puuttuu/, competitor, nineteen_shots
    end
  end

  context 'when invalid shot given' do
    before do
      race.update_attribute :sport_key, Sport::ILMAHIRVI
      @qs = QuickSave::ExtraShots.new(race.id, '10,*')
    end

    it 'does not save anything' do
      result = @qs.save
      expect_failure result, /virheellisen numeron/, competitor, competitor_shots
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
      competitor.update_attribute :extra_shots, extra_shots
      @qs = QuickSave::ExtraShots.new(race.id, '10,98')
    end

    it 'appends the shots' do
      result = @qs.save
      expect_success result, competitor, extra_shots + [9, 8]
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
