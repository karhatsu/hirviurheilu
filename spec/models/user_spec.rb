require 'spec_helper'

describe User do
  it "should create user with valid attrs" do
    FactoryGirl.create(:user)
  end

  describe "validation" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end
  
  describe "associations" do
    it { should have_and_belong_to_many(:roles) }
    it { should have_many(:race_rights) }
    it { should have_many(:races).through(:race_rights) }
    it { should have_and_belong_to_many(:cups) }
  end

  describe "rights" do
    context "default" do
      it "user should not be admin" do
        FactoryGirl.build(:user).should_not be_admin
      end

      it "user should not be official" do
        FactoryGirl.build(:user).should_not be_official
      end
    end

    describe "add admin rights" do
      it "should give admin rights for the user" do
        FactoryGirl.create(:role, :name => Role::ADMIN) unless Role.find_by_name(Role::ADMIN)
        user = FactoryGirl.build(:user)
        user.add_admin_rights
        user.should be_admin
      end
    end

    describe "add official rights" do
      it "should give official rights for the user" do
        FactoryGirl.create(:role, :name => Role::OFFICIAL) unless Role.find_by_name(Role::OFFICIAL)
        user = FactoryGirl.build(:user)
        user.add_official_rights
        user.should be_official
      end
    end
  end
  
  describe "#official_for_race?" do
    before do
      @race = FactoryGirl.create(:race)
      @user = FactoryGirl.create(:user)
    end

    it "should return false when no races for this user" do
      @user.should_not be_official_for_race(@race)
    end

    it "should return false when user is not official for the given race" do
      race = FactoryGirl.create(:race)
      @user.race_rights << RaceRight.new(:user_id => @user.id, :race_id => race.id)
      @user.reload
      @user.should_not be_official_for_race(@race)
    end

    it "should return true when user is official for the given race" do
      @user.race_rights << RaceRight.new(:user_id => @user.id, :race_id => @race.id)
      @user.reload
      @user.should be_official_for_race(@race)
    end
  end
  
  describe "#official_for_cup?" do
    before do
      @cup = FactoryGirl.create(:cup)
      @user = FactoryGirl.build(:user)
    end
    
    it "should return false when no cups for this user" do
      @user.should_not be_official_for_cup(@cup)
    end

    it "should return false when user is not official for the given cup" do
      cup = FactoryGirl.create(:cup)
      @user.cups << cup
      @user.should_not be_official_for_cup(@cup)
    end

    it "should return true when user is official for the given cup" do
      @user.cups << @cup
      @user.should be_official_for_cup(@cup)
    end
  end
  
  describe "#has_full_rights_for_race" do
    before do
      @user = FactoryGirl.create(:user)
      @race = FactoryGirl.create(:race)
    end
    
    it "should return false when user is not official for the race" do
      @user.should_not have_full_rights_for_race(@race)
    end
    
    it "should return false when user has only add competitors rights" do
      @user.race_rights.create!(:race => @race, :only_add_competitors => true)
      @user.should_not have_full_rights_for_race(@race) 
    end
    
    it "should return true when user has full rights" do
      @user.race_rights.create!(:race => @race, :only_add_competitors => false)
      @user.should have_full_rights_for_race(@race) 
    end
  end

  describe "offline usage" do
    describe "maximum amount of users" do
      before do
        FactoryGirl.create(:user)
      end

      context "when online usage" do
        before do
          Mode.stub(:offline?).and_return(false)
        end

        it "should not be limited" do
          FactoryGirl.create(:user)
        end
      end

      context "when offline usage" do
        before do
          Mode.stub(:offline?).and_return(true)
        end

        it "should be one" do
          FactoryGirl.build(:user).should_not be_valid
        end
      end
    end
  end
end
