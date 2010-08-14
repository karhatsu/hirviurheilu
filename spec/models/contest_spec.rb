require 'spec_helper'

describe Contest do
  describe "create" do
    it "should create contest with valid attrs" do
      Factory.create(:contest)
    end
  end

  describe "validation" do
    it "should require name" do
      Factory.build(:contest, :name => nil).should have(1).errors_on(:name)
    end

    it "should require location" do
      Factory.build(:contest, :location => nil).should have(1).errors_on(:location)
    end

    it "should require start date" do
      Factory.build(:contest, :start_date => nil).should have(1).errors_on(:start_date)
    end
  end
end
