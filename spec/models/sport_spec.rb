require 'spec_helper'

describe Sport do
  before do
    Sport.find_by_key(Sport::SKI) || FactoryGirl.create(:sport, :key => Sport::SKI)
    Sport.find_by_key(Sport::RUN) || FactoryGirl.create(:sport, :key => Sport::RUN)
  end
  
  describe "create" do
    it "should create sport with valid attrs" do
      FactoryGirl.create(:sport)
    end
  end

  describe "validation" do
    it "should require name" do
      FactoryGirl.build(:sport, :name => nil).should have(1).errors_on(:name)
    end

    it "should require key" do
      FactoryGirl.build(:sport, :key => nil).should have(1).errors_on(:key)
    end

    it "key should be unique" do
      FactoryGirl.create(:sport, :key => "XYZ")
      FactoryGirl.build(:sport, :key => "XYZ").should have(1).errors_on(:key)
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
      FactoryGirl.build(:sport, :key => Sport::SKI).should be_ski
    end

    it "should be false when key is not SKI" do
      FactoryGirl.build(:sport, :key => Sport::RUN).should_not be_ski
    end
  end

  describe "run?" do
    it "should be true when key is RUN" do
      FactoryGirl.build(:sport, :key => Sport::RUN).should be_run
    end

    it "should be false when key is not RUN" do
      FactoryGirl.build(:sport, :key => Sport::SKI).should_not be_run
    end
  end

  describe "find by key" do
    before do
      @ski = Sport.find_by_key(Sport::SKI)
      @run = Sport.find_by_key(Sport::RUN)
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

  describe "#default_sport" do
    before do
      @ski = Sport.find_by_key(Sport::SKI)
      @run = Sport.find_by_key(Sport::RUN)
      @time = Time.new
      Time.stub(:new).and_return(@time)
    end

    it "should return SKI when January" do
      @time.stub(:month).and_return(1)
      Sport.default_sport.key.should == Sport::SKI
    end
    it "should return SKI when February" do
      @time.stub(:month).and_return(2)
      Sport.default_sport.key.should == Sport::SKI
    end
    it "should return SKI when March" do
      @time.stub(:month).and_return(3)
      Sport.default_sport.key.should == Sport::SKI
    end
    it "should return SKI when April" do
      @time.stub(:month).and_return(4)
      Sport.default_sport.key.should == Sport::SKI
    end
    it "should return RUN when May" do
      @time.stub(:month).and_return(5)
      Sport.default_sport.key.should == Sport::RUN
    end
    it "should return RUN when June" do
      @time.stub(:month).and_return(6)
      Sport.default_sport.key.should == Sport::RUN
    end
    it "should return RUN when July" do
      @time.stub(:month).and_return(7)
      Sport.default_sport.key.should == Sport::RUN
    end
    it "should return RUN when August" do
      @time.stub(:month).and_return(8)
      Sport.default_sport.key.should == Sport::RUN
    end
    it "should return RUN when September" do
      @time.stub(:month).and_return(9)
      Sport.default_sport.key.should == Sport::RUN
    end
    it "should return RUN when October" do
      @time.stub(:month).and_return(10)
      Sport.default_sport.key.should == Sport::RUN
    end
    it "should return SKI when November" do
      @time.stub(:month).and_return(11)
      Sport.default_sport.key.should == Sport::SKI
    end
    it "should return SKI when December" do
      @time.stub(:month).and_return(12)
      Sport.default_sport.key.should == Sport::SKI
    end
  end
  
  describe "#initials" do
    it "should be HJ for run" do
      Sport.find_run.initials.should == 'HJ'
    end

    it "should be HH for ski" do
      Sport.find_ski.initials.should == 'HH'
    end
  end
end

