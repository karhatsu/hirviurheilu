require 'spec_helper'

RSpec.describe Event, type: :model do
  it 'create' do
    create :event
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
