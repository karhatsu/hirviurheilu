require 'spec_helper'

describe DefaultSeries do
  specify { Factory.create(:default_series) }

  describe "validation" do
    it "should require name" do
      Factory.build(:default_series, :name => nil).should have(1).errors_on(:name)
    end
  end
end
