require 'spec_helper'

describe Role do
  it "creates role with valid attrs" do
    FactoryGirl.create(:role)
  end

  it "should have ADMIN constant" do
    expect(Role::ADMIN).to eq('admin')
  end

  it "should have OFFICIAL constant" do
    expect(Role::OFFICIAL).to eq('official')
  end

  describe "validation" do
    it "should require name" do
      expect(FactoryGirl.build(:role, :name => nil)).to have(1).errors_on(:name)
    end

    it "should require unique name" do
      FactoryGirl.create(:role, :name => 'test')
      expect(FactoryGirl.build(:role, :name => 'test')).to have(1).errors_on(:name)
    end
  end
end
