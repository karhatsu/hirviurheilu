require 'spec_helper'

describe Club do
  describe "create" do
    it "should create club with valid attrs" do
      Factory.create(:club)
    end
  end

  describe "validation" do
    it { should validate_presence_of(:name) }

    describe "unique name" do
      before do
        Factory.create(:club)
      end
      it { should validate_uniqueness_of(:name).scoped_to(:race_id) }
    end
  end

  describe "associations" do
    it { should belong_to(:race) }
  end
end
