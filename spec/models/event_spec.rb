require 'spec_helper'

RSpec.describe Event, type: :model do
  it 'create' do
    create :event
  end

  describe 'associations' do
    it { should have_many(:races) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
