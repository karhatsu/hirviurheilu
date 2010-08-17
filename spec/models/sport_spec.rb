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
  
  describe "SKI" do
    it "should be SKI" do
      Sport::SKI.should == "SKI"
    end
  end

  describe "RUN" do
    it "should be RUN" do
      Sport::RUN.should == "RUN"
    end
  end

  describe "ski?" do
    it "should be true when key is SKI" do
      Factory.build(:sport, :key => Sport::SKI).should be_ski
    end

    it "should be false when key is not SKI" do
      Factory.build(:sport, :key => Sport::RUN).should_not be_ski
    end
  end

  describe "run?" do
    it "should be true when key is RUN" do
      Factory.build(:sport, :key => Sport::RUN).should be_run
    end

    it "should be false when key is not RUN" do
      Factory.build(:sport, :key => Sport::SKI).should_not be_run
    end
  end

  describe "find by key" do
    before do
      @ski = Factory.create(:sport, :key => Sport::SKI)
      @run = Factory.create(:sport, :key => Sport::RUN)
    end

    describe "#find_ski" do
      it "should return ski sport" do
        Sport.find_ski.should == @ski
      end
    end

    describe "#find_run" do
      it "should return run sport" do
        Sport.find_run.should == @run
      end
    end
  end
end

