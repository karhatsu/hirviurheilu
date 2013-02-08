require 'spec_helper'

describe Announcement do
  it "create" do
    FactoryGirl.create(:announcement)
  end
  
  describe "validations" do
    it { should validate_presence_of(:published) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
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
  
  describe "active" do
    before do
      FactoryGirl.create(:announcement, :active => true, :title => 'Active 1')
      FactoryGirl.create(:announcement, :active => false, :title => 'Non-active')
      FactoryGirl.create(:announcement, :active => true, :title => 'Active 2')
    end
    
    it "should return only active announcements" do
      announcements = Announcement.active
      announcements.length.should == 2
      announcements[0].title.should_not == 'Non-active'
      announcements[1].title.should_not == 'Non-active'
    end
  end
end
