require 'spec_helper'

describe Shot do
  it "should create shot with valid attrs" do
    create(:shot)
  end

  describe "associations" do
    it { is_expected.to belong_to(:competitor) }
  end

  describe "validation" do
    describe "value" do
      it { is_expected.to validate_numericality_of(:value) }
      it { is_expected.to allow_value(nil).for(:value) }
      it { is_expected.not_to allow_value(1.1).for(:value) }
      it { is_expected.not_to allow_value(-1).for(:value) }
      it { is_expected.to allow_value(0).for(:value) }
      it { is_expected.to allow_value(10).for(:value) }
      it { is_expected.not_to allow_value(11).for(:value) }
    end
  end

  describe 'callbacks' do
    context 'when shot is saved' do
      it 'sets competitor.has_result' do
        competitor = create :competitor
        create :shot, competitor: competitor
        expect(competitor.has_result?).to be_truthy
      end
    end
  end
end
