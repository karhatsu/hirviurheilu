require 'spec_helper'

RSpec.describe District, type: :model do
  it 'create' do
    create :district
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:short_name) }

    describe 'unique names' do
      before do
        create :district
      end
      it { should validate_uniqueness_of(:name) }
      it { should validate_uniqueness_of(:short_name) }
    end
  end
end
