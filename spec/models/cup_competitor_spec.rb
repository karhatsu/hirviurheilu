require 'spec_helper'

describe CupCompetitor do
  before do
    @cup = double(Cup)
    @cs = double(CupSeries, :cup => @cup)
    @competitor = mock_model(Competitor, :first_name => 'Mikko', :last_name => 'Miettinen')
    @cc = CupCompetitor.new(@cs, @competitor)
  end
  
  describe "#first_name" do
    it "should be the first name of the first competitor" do
      expect(@cc.first_name).to eq(@competitor.first_name)
    end
  end
  
  describe "#last_name" do
    it "should be the last name of the first competitor" do
      expect(@cc.last_name).to eq(@competitor.last_name)
    end
  end
  
  describe "#series_name" do
    it "should be the name of the series of the first competitor" do
      series = mock_model(Series, :name => 'M20')
      expect(@competitor).to receive(:series).and_return(series)
      expect(@cc.series_name).to eq('M20')
    end
  end

  describe "other competitors" do
    it "should accept other competitors when their name is the same as the first one's" do
      @cc << valid_competitor
      expect(@cc.competitors.length).to eq(2)
    end
    
    it "should not accept another competitor when first names differs" do
      expect { @cc << mock_model(Competitor, :first_name => 'Other',
        :last_name => @competitor.last_name) }.to raise_error
      expect(@cc.competitors.length).to eq(1)
    end
    
    it "should not accept another competitor when last names differs" do
      expect { @cc << mock_model(Competitor, :first_name => @competitor.first_name,
        :last_name => 'Other') }.to raise_error
      expect(@cc.competitors.length).to eq(1)
    end
  end
  
  describe "#points" do
    before do
      @competitor2 = valid_competitor
      @competitor3 = valid_competitor
      @cc << @competitor2
      @cc << @competitor3
      allow(@cup).to receive(:top_competitions).and_return(3)
    end
    
    context "when no points available in any of the competitions" do
      it "should be nil" do
        allow(@competitor).to receive(:points).with(false).and_return(nil)
        allow(@competitor2).to receive(:points).with(false).and_return(nil)
        allow(@competitor3).to receive(:points).with(false).and_return(nil)
        expect(@cc.points).to be_nil
      end
    end
    
    context "when points available only in some of the competitions" do
      context "but in less than top competitions" do
        it "should be nil" do
          allow(@cup).to receive(:top_competitions).and_return(3)
          allow(@competitor).to receive(:points).with(false).and_return(1000)
          allow(@competitor2).to receive(:points).with(false).and_return(nil)
          allow(@competitor3).to receive(:points).with(false).and_return(1100)
          expect(@cc.points).to be_nil
        end
      end
      
      context "and in at least top competitions" do
        it "should be sum of those that have points" do
          allow(@cup).to receive(:top_competitions).and_return(2)
          allow(@competitor).to receive(:points).with(false).and_return(1000)
          allow(@competitor2).to receive(:points).with(false).and_return(nil)
          allow(@competitor3).to receive(:points).with(false).and_return(1100)
          expect(@cc.points).to eq(1000 + 0 + 1100)
        end
      end
    end
    
    context "when points available in all the competitions" do
      before do
        allow(@competitor).to receive(:points).with(false).and_return(1000)
        allow(@competitor2).to receive(:points).with(false).and_return(2000)
        allow(@competitor3).to receive(:points).with(false).and_return(3000)
      end
      
      it "should be sum of points in individual competitions when all competitions matter" do
        allow(@cup).to receive(:top_competitions).and_return(3)
        expect(@cc.points).to eq(1000 + 2000 + 3000)
      end
      
      it "should be sum of top two points in individual competitions when top two of them matter" do
        allow(@cup).to receive(:top_competitions).and_return(2)
        expect(@cc.points).to eq(2000 + 3000)
      end
    end
  end
  
  describe "#points!" do
    before do
      @competitor2 = valid_competitor
      @competitor3 = valid_competitor
      @cc << @competitor2
      @cc << @competitor3
      allow(@cup).to receive(:top_competitions).and_return(3)
    end
    
    context "when no points available in any of the competitions" do
      it "should be nil" do
        allow(@competitor).to receive(:points).with(false).and_return(nil)
        allow(@competitor2).to receive(:points).with(false).and_return(nil)
        allow(@competitor3).to receive(:points).with(false).and_return(nil)
        expect(@cc.points!).to be_nil
      end
    end
    
    context "when points available only in some of the competitions" do
      context "but in less than top competitions" do
        it "should be sum of those that have points" do
          allow(@cup).to receive(:top_competitions).and_return(3)
          allow(@competitor).to receive(:points).with(false).and_return(1000)
          allow(@competitor2).to receive(:points).with(false).and_return(nil)
          allow(@competitor3).to receive(:points).with(false).and_return(1100)
          expect(@cc.points!).to eq(1000 + 0 + 1100)
        end
      end
      
      context "and in at least top competitions" do
        it "should be sum of those that have points" do
          allow(@cup).to receive(:top_competitions).and_return(2)
          allow(@competitor).to receive(:points).with(false).and_return(1000)
          allow(@competitor2).to receive(:points).with(false).and_return(nil)
          allow(@competitor3).to receive(:points).with(false).and_return(1100)
          expect(@cc.points!).to eq(1000 + 0 + 1100)
        end
      end
    end
    
    context "when points available in all the competitions" do
      before do
        allow(@competitor).to receive(:points).with(false).and_return(1000)
        allow(@competitor2).to receive(:points).with(false).and_return(2000)
        allow(@competitor3).to receive(:points).with(false).and_return(3000)
      end
      
      it "should be sum of points in individual competitions when all competitions matter" do
        allow(@cup).to receive(:top_competitions).and_return(3)
        expect(@cc.points!).to eq(1000 + 2000 + 3000)
      end
      
      it "should be sum of top two points in individual competitions when top two of them matter" do
        allow(@cup).to receive(:top_competitions).and_return(2)
        expect(@cc.points!).to eq(2000 + 3000)
      end
    end
  end
  
  describe "#competitor_for_race" do
    before do
      allow(@competitor).to receive(:race).and_return(mock_model(Race))
    end
    
    it "should be nil when no match" do
      expect(@cc.competitor_for_race(FactoryGirl.build(:race))).to be_nil
    end
    
    it "should be the competitor that belongs to the given race" do
      competitor = valid_competitor
      race = FactoryGirl.build(:race)
      allow(competitor).to receive(:race).and_return(race)
      @cc << competitor
      expect(@cc.competitor_for_race(race)).to eq(competitor)
    end
  end

  describe ".name for competitor" do
    it "should be competitor last name, space, first name in lower case" do
      competitor = mock_model(Competitor, :first_name => 'First', :last_name => 'Last')
      expect(CupCompetitor.name(competitor)).to eq('last first')
    end

    it "should trim spaces" do
      competitor = mock_model(Competitor, :first_name => ' First  ', :last_name => '  Last ')
      expect(CupCompetitor.name(competitor)).to eq('last first')
    end
  end
  
  def valid_competitor
    mock_model(Competitor, :first_name => @competitor.first_name, :last_name => @competitor.last_name)
  end
end
