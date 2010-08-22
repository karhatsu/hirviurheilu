require 'spec_helper'

describe Race do
  describe "create" do
    it "should create race with valid attrs" do
      Factory.create(:race)
    end
  end

  describe "validation" do
    it "should require sport" do
      Factory.build(:race, :sport => nil).should have(1).errors_on(:sport)
    end

    it "should require name" do
      Factory.build(:race, :name => nil).should have(1).errors_on(:name)
    end

    it "should require location" do
      Factory.build(:race, :location => nil).should have(1).errors_on(:location)
    end

    it "should require start date" do
      Factory.build(:race, :start_date => nil).should have(1).errors_on(:start_date)
    end
  end
end
