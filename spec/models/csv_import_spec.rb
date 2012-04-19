# encoding: UTF-8
require 'spec_helper'

describe CsvImport do
  before do
    @race = FactoryGirl.create(:race)
    series = FactoryGirl.build(:series, :race => @race, :name => 'N')
    @race.series << series
    series.age_groups << FactoryGirl.build(:age_group, :series => series, :name => 'N50')
    @race.series << FactoryGirl.build(:series, :race => @race, :name => 'M40')
    @race.clubs << FactoryGirl.build(:club, :race => @race, :name => 'PS')
  end
  
  context "when not correct amount of columns in each row" do
    before do
      @ci = CsvImport.new(@race, test_file_path('import_with_invalid_structure.csv'))
    end
    
    it "#save should return false" do
      @ci.save.should be_false
    end
    
    it "#errors should contain a message about invalid file format" do
      @ci.should have(1).errors
      @ci.errors[0].should == 'Virheellinen rivi tiedostossa: Matti,Miettinen,SS,M40,additional column'
    end
    
    it "there should be no new competitors for the race" do
      @race.should have(0).competitors
    end
  end
  
  context "when correct amount of columns" do
    context "when all series and age groups exist" do
      context "and file encoding is UTF-8" do
        before do
          @ci = CsvImport.new(@race, test_file_path('import_valid.csv'))
        end
        
        describe "#save" do
          it "should save the defined competitors and new clubs to the database and return true" do
            @ci.save.should be_true
            @race.reload
            @race.should have(4).competitors
            c = @race.competitors.order('id')[0]
            c.first_name.should == 'Heikki'
            c.last_name.should == 'Räsänen'
            c.series.name.should == 'M40'
            c.club.name.should == 'SS'
            c = @race.competitors.order('id')[1]
            c.first_name.should == 'Minna'
            c.last_name.should == 'Miettinen'
            c.series.name.should == 'N'
            c.age_group.should be_nil
            c.club.name.should == 'PS'
            c = @race.competitors.order('id')[2]
            c.first_name.should == 'Maija'
            c.last_name.should == 'Hämäläinen'
            c.series.name.should == 'N'
            c.age_group.name.should == 'N50'
            c.club.name.should == 'SS'
            c = @race.competitors.order('id')[3]
            c.first_name.should == 'Minna'
            c.last_name.should == 'Hämäläinen'
            c.series.name.should == 'N'
            c.age_group.name.should == 'N50'
            c.club.name.should == 'SS'
            @race.should have(2).clubs
          end
        end
        
        it "#errors should be empty" do
          @ci.should have(0).errors
        end
      end
      
      context "and file encoding is Windows-1252" do
        before do
          @ci = CsvImport.new(@race, test_file_path('import_valid_windows-1252.csv'))
        end
        
        describe "#save" do
          it "should save the defined competitors and new clubs to the database and return true" do
            @ci.save.should be_true
            @race.reload
            @race.should have(3).competitors
            c = @race.competitors.order('id')[0]
            c.first_name.should == 'Timo'
            c.last_name.should == 'Malinen'
            c.series.name.should == 'M40'
            c.club.name.should == 'Ampumaseura'
            c = @race.competitors.order('id')[1]
            c.first_name.should == 'Toni'
            c.last_name.should == 'Miettinen'
            c.series.name.should == 'M40'
            c.club.name.should == 'Kuikan Erä'
            c = @race.competitors.order('id')[2]
            c.first_name.should == 'Teppo'
            c.last_name.should == 'Ylönen'
            c.series.name.should == 'M40'
            c.club.name.should == 'Sum Um'
          end
        end
        
        it "#errors should be empty" do
          @ci.should have(0).errors
        end
      end
    end
    
    context "when an unknown series" do
      before do
        @race.series.find_by_name('M40').destroy
        @ci = CsvImport.new(@race, test_file_path('import_valid.csv'))
      end
    
      it "#save should return false" do
        @ci.save.should be_false
      end
      
      it "#errors should contain a message about unknown series" do
        @ci.should have(1).errors
        @ci.errors[0].should == "Tuntematon sarja/ikäryhmä: 'M40'"
      end
      
      it "there should be no new competitors for the race" do
        @race.should have(0).competitors
      end
    end
    
    context "when the same unknown series or age group for two competitors" do
      before do
        @race.age_groups.find_by_name('N50').destroy
        @ci = CsvImport.new(@race, test_file_path('import_valid.csv'))
      end
    
      it "#save should return false" do
        @ci.save.should be_false
      end
      
      it "there should be only one error message" do
        @ci.should have(1).errors
      end
      
      it "the error message should be about unknown series" do
        @ci.errors[0].should == "Tuntematon sarja/ikäryhmä: 'N50'"
      end
      
      it "there should be no new competitors for the race" do
        @race.should have(0).competitors
      end
    end
    
    context "when empty column in the file" do
      before do
        @ci = CsvImport.new(@race, test_file_path('import_with_empty_column.csv'))
      end
    
      it "#save should return false" do
        @ci.save.should be_false
      end
      
      it "#errors should contain a message about missing data" do
        @ci.should have(1).errors
      end
      
      it "the error message should contain the errorneous row" do
        @ci.errors[0].should == "Riviltä puuttuu tietoja: Minna,Miettinen,,N"
      end
      
      it "there should be no new competitors for the race" do
        @race.should have(0).competitors
      end
    end
    
    context "when some column contains only spaces" do
      before do
        @ci = CsvImport.new(@race, test_file_path('import_with_spaces_in_column.csv'))
      end
    
      it "#save should return false" do
        @ci.save.should be_false
      end
      
      it "#errors should contain a message about missing data" do
        @ci.should have(1).errors
      end
      
      it "the error message should contain the errorneous row" do
        @ci.errors[0].should == "Riviltä puuttuu tietoja: Minna,  ,PS,N"
      end
      
      it "there should be no new competitors for the race" do
        @race.should have(0).competitors
      end
    end
    
    context "when the file contains two errorneous rows" do
      before do
        @ci = CsvImport.new(@race, test_file_path('import_with_multiple_errors.csv'))
      end
    
      it "#save should return false" do
        @ci.save.should be_false
      end
      
      it "#errors should contain two errors" do
        @ci.should have(2).errors
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
