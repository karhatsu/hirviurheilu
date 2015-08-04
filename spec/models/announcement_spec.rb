require 'spec_helper'

describe Announcement do
  it "create" do
    create(:announcement)
  end
  
  describe "validations" do
    it { is_expected.to validate_presence_of(:published) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
  end
  
  describe "default scope" do
    before do
      create(:announcement, :published => '2013-02-08')
      create(:announcement, :published => '2013-02-09')
      create(:announcement, :published => '2013-02-07')
    end
    
    it "should order by descending published time" do
      announcements = Announcement.all
      expect(announcements[0].published.day).to eq(9)
      expect(announcements[1].published.day).to eq(8)
      expect(announcements[2].published.day).to eq(7)
    end
  end
  
  describe '.active' do
    before do
      create(:announcement, :active => true, :title => 'Active 1')
      create(:announcement, :active => false, :title => 'Non-active')
      create(:announcement, :active => true, :title => 'Active 2')
    end
    
    it "should return only active announcements" do
      announcements = Announcement.active
      expect(announcements.length).to eq(2)
      expect(announcements[0].title).not_to eq('Non-active')
      expect(announcements[1].title).not_to eq('Non-active')
    end
  end

  describe '.front_page' do
    before do
      create(:announcement, front_page: true, title: 'Front 1')
      create(:announcement, front_page: false, title: 'Non-front')
      create(:announcement, front_page: true, title: 'Front 2')
    end

    it "should return only active front page announcements" do
      announcements = Announcement.front_page
      expect(announcements.length).to eq(2)
      expect(announcements[0].title).not_to eq('Non-front')
      expect(announcements[1].title).not_to eq('Non-front')
    end
  end
end
