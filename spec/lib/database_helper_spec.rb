require 'spec_helper'
require 'database_helper.rb'

describe DatabaseHelper do
  context "when postgres" do
    before do
      allow(DatabaseHelper).to receive(:postgres?).and_return(true)
    end

    it "true value should be true" do
      expect(DatabaseHelper.true_value).to be_truthy
    end

    it "false value should be false" do
      expect(DatabaseHelper.false_value).to be_falsey
    end
  end

  context "when sqlite3" do
    before do
      allow(DatabaseHelper).to receive(:postgres?).and_return(false)
    end

    it "true value should be 't'" do
      expect(DatabaseHelper.true_value).to eq("'t'")
    end

    it "false value should be 'f'" do
      expect(DatabaseHelper.false_value).to eq("'f'")
    end
  end

  describe "#boolean_value" do
    it "should be #true_value for true" do
      allow(DatabaseHelper).to receive(:true_value).and_return('TRUE')
      expect(DatabaseHelper.boolean_value(true)).to eq('TRUE')
    end

    it "should be #false_value for false" do
      allow(DatabaseHelper).to receive(:false_value).and_return('FALSE')
      expect(DatabaseHelper.boolean_value(nil)).to eq('FALSE')
    end
  end
end
