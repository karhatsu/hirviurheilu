require 'spec_helper'

describe CsvImport do
  before do
    @race = Factory.create(:race)
    @race.series << Factory.build(:series, :race => @race, :name => 'N')
    @race.series << Factory.build(:series, :race => @race, :name => 'M40')
    @race.clubs << Factory.build(:club, :race => @race, :name => 'PS')
  end
  
  context "when not correct amount of columns in each row" do
    before do
      @ci = CsvImport.new(@race, test_file_path('invalid_import.csv'))
    end
    
    it "#save should return false" do
      @ci.save.should be_false
    end
    
    it "#errors should contain a message about invalid file format" do
      @ci.should have(1).errors
      @ci.errors[0].should == 'Tiedoston rakenne virheellinen'
    end
    
    it "there should be no new competitors for the race" do
      @race.should have(0).competitors
    end
  end
  
  context "when correct amount of data" do
    before do
      @ci = CsvImport.new(@race, test_file_path('valid_import.csv'))
    end
    
    context "when all series exist" do
      describe "#save" do
        it "should save the defined competitors and new clubs to the database and return true" do
          @ci.save.should be_true
          @race.reload
          @race.should have(2).competitors
          c = @race.competitors.order('id')[0]
          c.first_name.should == 'Heikki'
          c.last_name.should == 'Räsänen'
          c.series.name.should == 'M40'
          c.club.name.should == 'SS'
          c = @race.competitors.order('id')[1]
          c.first_name.should == 'Minna'
          c.last_name.should == 'Miettinen'
          c.series.name.should == 'N'
          c.club.name.should == 'PS'
          @race.should have(2).clubs
        end
      end
      
      it "#errors should be empty" do
        @ci.should have(0).errors
      end
    end
    
    context "when an unknown series" do
      before do
        @race.series.find_by_name('M40').destroy
        @ci = CsvImport.new(@race, test_file_path('valid_import.csv'))
      end
    
      it "#save should return false" do
        @ci.save.should be_false
      end
      
      it "#errors should contain a message about unknown series" do
        @ci.should have(1).errors
        @ci.errors[0].should == "Tuntematon sarja: 'M40'"
      end
      
      it "there should be no new competitors for the race" do
        @race.should have(0).competitors
      end
    end
    
    context "when an empty competitor attribute in the file" do
      before do
        @ci = CsvImport.new(@race, test_file_path('invalid_competitor_import.csv'))
      end
    
      it "#save should return false" do
        @ci.save.should be_false
      end
      
      it "#errors should contain a message about missing data" do
        @ci.should have(1).errors
      end
      
      it "there should be no new competitors for the race" do
        @race.should have(0).competitors
      end
    end
    
    context "when club name is empty in the file" do
      before do
        @ci = CsvImport.new(@race, test_file_path('invalid_club_import.csv'))
      end
    
      it "#save should return false" do
        @ci.save.should be_false
      end
      
      it "#errors should contain a message about missing data" do
        @ci.should have(1).errors
      end
      
      it "there should be no new competitors for the race" do
        @race.should have(0).competitors
      end
    end
  end
  
  def test_file_path(file_name)
    File.join(Rails.root, 'spec', 'files', file_name)
  end
end
