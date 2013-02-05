require 'spec_helper'

describe Announcement do
  it "create" do
    FactoryGirl.create(:announcement)
  end
  
  describe "validations" do
    it { should validate_presence_of(:published) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:active) }
  end
end
