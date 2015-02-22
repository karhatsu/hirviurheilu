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
      expect(FactoryGirl.build(:sport, :name => nil)).to have(1).errors_on(:name)
    end

    it "should require key" do
      expect(FactoryGirl.build(:sport, :key => nil)).to have(1).errors_on(:key)
    end

    it "key should be unique" do
      FactoryGirl.create(:sport, :key => "XYZ")
      expect(FactoryGirl.build(:sport, :key => "XYZ")).to have(1).errors_on(:key)
    end
  end
  
  describe "SKI" do
    it "should be SKI" do
      expect(Sport::SKI).to eq("SKI")
    end
  end

  describe "RUN" do
    it "should be RUN" do
      expect(Sport::RUN).to eq("RUN")
    end
  end

  describe "ski?" do
    it "should be true when key is SKI" do
      expect(FactoryGirl.build(:sport, :key => Sport::SKI)).to be_ski
    end

    it "should be false when key is not SKI" do
      expect(FactoryGirl.build(:sport, :key => Sport::RUN)).not_to be_ski
    end
  end

  describe "run?" do
    it "should be true when key is RUN" do
      expect(FactoryGirl.build(:sport, :key => Sport::RUN)).to be_run
    end

    it "should be false when key is not RUN" do
      expect(FactoryGirl.build(:sport, :key => Sport::SKI)).not_to be_run
    end
  end

  describe "find by key" do
    before do
      @ski = Sport.find_by_key(Sport::SKI)
      @run = Sport.find_by_key(Sport::RUN)
    end

    describe "#find_ski" do
      it "should return ski sport" do
        expect(Sport.find_ski).to eq(@ski)
      end
    end

    describe "#find_run" do
      it "should return run sport" do
        expect(Sport.find_run).to eq(@run)
      end
    end
  end

  describe "#default_sport" do
    before do
      @ski = Sport.find_by_key(Sport::SKI)
      @run = Sport.find_by_key(Sport::RUN)
      @time = Time.new
      allow(Time).to receive(:new).and_return(@time)
    end

    it "should return SKI when January" do
      allow(@time).to receive(:month).and_return(1)
      expect(Sport.default_sport.key).to eq(Sport::SKI)
    end
    it "should return SKI when February" do
      allow(@time).to receive(:month).and_return(2)
      expect(Sport.default_sport.key).to eq(Sport::SKI)
    end
    it "should return SKI when March" do
      allow(@time).to receive(:month).and_return(3)
      expect(Sport.default_sport.key).to eq(Sport::SKI)
    end
    it "should return SKI when April" do
      allow(@time).to receive(:month).and_return(4)
      expect(Sport.default_sport.key).to eq(Sport::SKI)
    end
    it "should return RUN when May" do
      allow(@time).to receive(:month).and_return(5)
      expect(Sport.default_sport.key).to eq(Sport::RUN)
    end
    it "should return RUN when June" do
      allow(@time).to receive(:month).and_return(6)
      expect(Sport.default_sport.key).to eq(Sport::RUN)
    end
    it "should return RUN when July" do
      allow(@time).to receive(:month).and_return(7)
      expect(Sport.default_sport.key).to eq(Sport::RUN)
    end
    it "should return RUN when August" do
      allow(@time).to receive(:month).and_return(8)
      expect(Sport.default_sport.key).to eq(Sport::RUN)
    end
    it "should return RUN when September" do
      allow(@time).to receive(:month).and_return(9)
      expect(Sport.default_sport.key).to eq(Sport::RUN)
    end
    it "should return RUN when October" do
      allow(@time).to receive(:month).and_return(10)
      expect(Sport.default_sport.key).to eq(Sport::RUN)
    end
    it "should return SKI when November" do
      allow(@time).to receive(:month).and_return(11)
      expect(Sport.default_sport.key).to eq(Sport::SKI)
    end
    it "should return SKI when December" do
      allow(@time).to receive(:month).and_return(12)
      expect(Sport.default_sport.key).to eq(Sport::SKI)
    end
  end
  
  describe "#initials" do
    it "should be HJ for run" do
      expect(Sport.find_run.initials).to eq('HJ')
    end

    it "should be HH for ski" do
      expect(Sport.find_ski.initials).to eq('HH')
    end
  end
end

