require 'spec_helper'

describe Club do
  describe "create" do
    it "should create club with valid attrs" do
      FactoryGirl.create(:club)
    end
  end

  describe "validation" do
    it { should validate_presence_of(:name) }
    it { should_not validate_presence_of(:long_name) }
    it { should allow_value(nil).for(:long_name) }

    describe "unique name" do
      before do
        FactoryGirl.create(:club, :long_name => 'Long name')
      end
      it { should validate_uniqueness_of(:name).scoped_to(:race_id) }
      it { should validate_uniqueness_of(:long_name).scoped_to(:race_id) }

      it "should allow two nil long names for same race" do
        club = FactoryGirl.create(:club, :long_name => nil)
        FactoryGirl.build(:club, :long_name => nil, :race_id => club.race.id).
          should be_valid
      end

      it "should convert empty strings to nils for long names" do
        club = FactoryGirl.create(:club, :long_name => '')
        club.long_name.should be_nil
        FactoryGirl.build(:club, :long_name => '', :race_id => club.race.id).
          should be_valid
      end
    end
  end

  describe "associations" do
    it { should belong_to(:race) }
    it { should have_many(:competitors) }
  end

  describe "removal" do
    it "should be allowed when no competitors" do
      club = FactoryGirl.create(:club)
      club.destroy
      club.should be_destroyed
    end

    it "should not be allowed when club has competitors" do
      club = FactoryGirl.create(:club)
      competitor = FactoryGirl.create(:competitor, :club => club)
      club.reload
      club.should have(1).competitors
      club.destroy
      club.should_not be_destroyed
    end
  end

  describe "#result_name" do
    it "should return long name when long name set" do
      club = FactoryGirl.create(:club, :name => 'PS', :long_name => 'Pohjois-Savo')
      club.expanded.should == 'Pohjois-Savo'
    end

    it "should return name when long name not set" do
      club = FactoryGirl.create(:club, :name => 'PS')
      club.expanded.should == 'PS'
    end
  end
end
