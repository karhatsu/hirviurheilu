require 'spec_helper'

describe SubSeries do
  it "should create sub_series with valid attrs" do
    Factory.create(:sub_series)
  end

  describe "validation" do
    it "should require name" do
      Factory.build(:sub_series, :name => nil).should have(1).errors_on(:name)
    end

    it "should require series" do
      Factory.build(:sub_series, :series => nil).should have(1).errors_on(:series)
    end
  end
end
