require 'spec_helper'

describe ActivationKey do
  describe "validations" do
    it { is_expected.to validate_presence_of(:comment) }
  end

  describe "#valid?" do
    it "should return false with wrong parameters" do
      expect(ActivationKey.valid?('some@email.com', 'mypass', 'mykey')).to be_falsey
    end

    it "should return true with correct parameters (lower case)" do
      expect(ActivationKey.valid?('online@hirviurheilu.com', 'online', '5bd11fe7d2')).to be_truthy
    end

    it "should return true with correct parameters (upper case)" do
      expect(ActivationKey.valid?('online@hirviurheilu.com', 'online', '5BD11FE7D2')).to be_truthy
    end
  end
end

