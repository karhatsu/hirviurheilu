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
  
  describe "default scope" do
    before do
      FactoryGirl.create(:announcement, :published => '2013-02-08')
      FactoryGirl.create(:announcement, :published => '2013-02-09')
      FactoryGirl.create(:announcement, :published => '2013-02-07')
    end
    
    it "should order by descending published time" do
      announcements = Announcement.all
      announcements[0].published.day.should == 9
      announcements[1].published.day.should == 8
      announcements[2].published.day.should == 7
    end
  end
end
