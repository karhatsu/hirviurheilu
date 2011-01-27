require 'spec_helper'

describe User do
  it "should create user with valid attrs" do
    Factory.create(:user)
  end

  describe "validation" do
    it "should require first name" do
      Factory.build(:user, :first_name => nil).should have(1).errors_on(:first_name)
    end

    it "should require last name" do
      Factory.build(:user, :last_name => nil).should have(1).errors_on(:last_name)
    end
  end

  describe "rights" do
    context "default" do
      it "user should not be admin" do
        Factory.build(:user).should_not be_admin
      end

      it "user should not be official" do
        Factory.build(:user).should_not be_official
      end
    end

    describe "add admin rights" do
      it "should give admin rights for the user" do
        Factory.create(:role, :name => Role::ADMIN) unless Role.find_by_name(Role::ADMIN)
        user = Factory.build(:user)
        user.add_admin_rights
        user.should be_admin
      end
    end

    describe "add official rights" do
      it "should give official rights for the user" do
        Factory.create(:role, :name => Role::OFFICIAL) unless Role.find_by_name(Role::OFFICIAL)
        user = Factory.build(:user)
        user.add_official_rights
        user.should be_official
      end
    end
  end

  describe "#official_for_race?" do
    before do
      @race = Factory.create(:race)
      @user = Factory.build(:user)
    end

    it "should return false when no races for this user" do
      @user.should_not be_official_for_race(@race)
    end

    it "should return false when user is not official for the given race" do
      race = Factory.create(:race)
      @user.races << race
      @user.should_not be_official_for_race(@race)
    end

    it "should return true when user is official for the given race" do
      @user.races << @race
      @user.should be_official_for_race(@race)
    end
  end

  describe "offline usage" do
    describe "maximum amount of users" do
      before do
        Factory.create(:user)
      end

      context "when online usage" do
        it "should not be limited" do
          Factory.create(:user)
        end
      end

      context "when offline usage" do
        before do
          Rails.stub!(:env).and_return('offline')
        end

        it "should be one" do
          Factory.build(:user).should_not be_valid
        end
      end
    end
  end
end
