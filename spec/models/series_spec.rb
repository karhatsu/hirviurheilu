require 'spec_helper'

describe Series do
  describe "create" do
    it "should create series with valid attrs" do
      Factory.create(:series)
    end
  end

  describe "validation" do
    it "should require name" do
      Factory.build(:series, :name => nil).should have(1).errors_on(:name)
    end
  end
end
