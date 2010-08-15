require 'spec_helper'

describe Club do
  describe "create" do
    it "should create club with valid attrs" do
      Factory.create(:club)
    end
  end

  describe "validation" do
    it "should require name" do
      Factory.build(:club, :name => nil).should have(1).errors_on(:name)
    end

    it "should require unique name" do
      Factory.create(:club, :name => 'Abc')
      Factory.build(:club, :name => 'Abc').should have(1).errors_on(:name)
    end
  end
end
