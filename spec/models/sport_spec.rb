require 'spec_helper'

describe Sport do
  describe "create" do
    it "should create sport with valid attrs" do
      Factory.create(:sport)
    end
  end

  describe "validation" do
    it "should require name" do
      Factory.build(:sport, :name => nil).should have(1).errors_on(:name)
    end

    it "should require key" do
      Factory.build(:sport, :key => nil).should have(1).errors_on(:key)
    end

    it "key should be unique" do
      Factory.create(:sport, :key => "XYZ")
      Factory.build(:sport, :key => "XYZ").should have(1).errors_on(:key)
    end
  end
end

