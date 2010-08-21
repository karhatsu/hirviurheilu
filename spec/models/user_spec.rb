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
end
