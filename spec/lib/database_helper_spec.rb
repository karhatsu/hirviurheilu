require 'spec_helper'
require 'database_helper.rb'

describe DatabaseHelper do
  context "when postgres" do
    before do
      DatabaseHelper.stub(:postgres?).and_return(true)
    end

    it "true value should be true" do
      DatabaseHelper.true_value.should be_true
    end

    it "false value should be false" do
      DatabaseHelper.false_value.should be_false
    end
  end

  context "when sqlite3" do
    before do
      DatabaseHelper.stub(:postgres?).and_return(false)
    end

    it "true value should be 't'" do
      DatabaseHelper.true_value.should == "'t'"
    end

    it "false value should be 'f'" do
      DatabaseHelper.false_value.should == "'f'"
    end
  end

  describe "#boolean_value" do
    it "should be #true_value for true" do
      DatabaseHelper.stub(:true_value).and_return('TRUE')
      DatabaseHelper.boolean_value(true).should == 'TRUE'
    end

    it "should be #false_value for false" do
      DatabaseHelper.stub(:false_value).and_return('FALSE')
      DatabaseHelper.boolean_value(nil).should == 'FALSE'
    end
  end
end
