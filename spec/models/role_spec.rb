require 'spec_helper'

describe Role do
  it "creates role with valid attrs" do
    FactoryGirl.create(:role)
  end

  it "should have ADMIN constant" do
    Role::ADMIN.should == 'admin'
  end

  it "should have OFFICIAL constant" do
    Role::OFFICIAL.should == 'official'
  end

  describe "validation" do
    it "should require name" do
      FactoryGirl.build(:role, :name => nil).should have(1).errors_on(:name)
    end

    it "should require unique name" do
      FactoryGirl.create(:role, :name => 'test')
      FactoryGirl.build(:role, :name => 'test').should have(1).errors_on(:name)
    end
  end
end
