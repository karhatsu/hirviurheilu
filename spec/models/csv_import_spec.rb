require 'spec_helper'

describe CsvImport do

  shared_examples_for 'failed import' do |error_count|
    it "#save should return false" do
      expect(@ci.save).to be_falsey
    end

    it "there should be no new competitors for the race" do
      expect(@race.competitors.size).to eq(0)
    end

    it "should contain correct amount of errors" do
      expect(@ci.errors.size).to eq(error_count)
    end
  end

  before do
    @race = create :race
    @series = create :series, race: @race, name: 'N'
    create :age_group, series: @series, name: 'N50'
    @youth_series = create :series, race: @race, name: 'S17'
    create :age_group, series: @youth_series, name: 'P17'
    create :series, race: @race, name: 'M40'
    create :club, race: @race, name: 'PS'
  end

  context "when not correct amount of columns in each row" do
    before do
      @ci = CsvImport.new(@race, test_file_path('import_with_invalid_structure.csv'))
    end

    it_should_behave_like 'failed import', 1

    it "#errors should contain a message about invalid file format" do
      expect(@ci.errors[0]).to eq('Virheellinen rivi tiedostossa: Matti,Miettinen,SS,M40,additional column')
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
            expect(@ci.save).to be_truthy
            @race.reload
            expect(@race.competitors.size).to eq(5)
            competitors = @race.competitors.except(:order).order('id')
            expect_competitor competitors[0], 'Heikki', 'Räsänen', 'SS', 'M40'
            expect_competitor competitors[1], 'Minna', 'Miettinen', 'PS', 'N'
            expect_competitor competitors[2], 'Maija', 'Hämäläinen', 'SS', 'N', 'N50'
            expect_competitor competitors[3], 'Minna', 'Hämäläinen', 'SS', 'N', 'N50'
            expect(@race.clubs.size).to eq(2)
          end
        end

        it "#errors should be empty" do
          expect(@ci.errors.size).to eq(0)
        end
      end

      context "and file encoding is Windows-1252" do
        before do
          @ci = CsvImport.new(@race, test_file_path('import_valid_windows-1252.csv'))
        end

        describe "#save" do
          it "should save the defined competitors and new clubs to the database and return true" do
            expect(@ci.save).to be_truthy
            @race.reload
            expect(@race.competitors.size).to eq(3)
            competitors = @race.competitors.order('id')
            expect_competitor competitors[0], 'Timo', 'Malinen', 'Ampumaseura', 'M40'
            expect_competitor competitors[1], 'Toni', 'Miettinen', 'Kuikan Erä', 'M40'
            expect_competitor competitors[2], 'Teppo', 'Ylönen', 'Sum Um', 'M40'
          end
        end

        it "#errors should be empty" do
          expect(@ci.errors.size).to eq(0)
        end
      end
    end

    context "when an unknown series" do
      before do
        @race.series.find_by_name('M40').destroy
        @ci = CsvImport.new(@race, test_file_path('import_valid.csv'))
      end

      it_should_behave_like 'failed import', 1

      it "#errors should contain a message about unknown series" do
        expect(@ci.errors[0]).to eq("Tuntematon sarja/ikäryhmä: 'M40'")
      end
    end

    context "when the same unknown series or age group for two competitors" do
      before do
        @race.age_groups.find_by_name('N50').destroy
        @ci = CsvImport.new(@race, test_file_path('import_valid.csv'))
      end

      it_should_behave_like 'failed import', 1

      it "the error message should be about unknown series" do
        expect(@ci.errors[0]).to eq("Tuntematon sarja/ikäryhmä: 'N50'")
      end
    end

    context "when empty column in the file" do
      before do
        @ci = CsvImport.new(@race, test_file_path('import_with_empty_column.csv'))
      end

      it_should_behave_like 'failed import', 1

      it "the error message should contain the erroneous row" do
        expect(@ci.errors[0]).to eq("Riviltä puuttuu tietoja: Minna,Miettinen,,N")
      end
    end

    context "when some column contains only spaces" do
      before do
        @ci = CsvImport.new(@race, test_file_path('import_with_spaces_in_column.csv'))
      end

      it_should_behave_like 'failed import', 1

      it "the error message should contain the erroneous row" do
        expect(@ci.errors[0]).to eq("Riviltä puuttuu tietoja: Minna,  ,PS,N")
      end
    end

    context "when the file contains two erroneous rows" do
      before do
        @ci = CsvImport.new(@race, test_file_path('import_with_multiple_errors.csv'))
      end

      it_should_behave_like 'failed import', 2
    end

    context 'when the file contains duplicate competitors' do
      before do
        @ci = CsvImport.new(@race, test_file_path('import_with_duplicate_competitors.csv'))
      end

      it_should_behave_like 'failed import', 1

      it "#errors should contain one error about duplicate competitors" do
        expect(@ci.errors.first).to eq('Tiedosto sisältää saman kilpailijan kahteen kertaan: Heikki,Räsänen,SS,M40')
      end
    end

    context 'when youth series without age group' do
      before do
        @ci = CsvImport.new @race, test_file_path('import_without_youth_age_group.csv')
      end

      it_should_behave_like 'failed import', 1

      it "#errors should contain an error about missing age group" do
        expect(@ci.errors.first).to eq('Kilpailijalle pitää määrittää ikäryhmä: Topi Turunen (S17)')
      end
    end
  end

  context "when mixed start order" do
    before do
      @race.start_order = Race::START_ORDER_MIXED
      @race.save!
    end

    it "should reject file that would be valid for start order by series" do
      @ci = CsvImport.new(@race, test_file_path('import_valid.csv'))
      expect(@ci.errors.size).to eq(1)
    end

    it "should accept file with start number and order" do
      @ci = CsvImport.new(@race, test_file_path('import_valid_mixed_start_order.csv'))
      expect(@ci.save).to be_truthy
      expect(@race.competitors.size).to eq(2)
      expect(@race.series.first.competitors.first.number).to eq(5)
      expect(@race.series.first.competitors.first.start_time.strftime('%H:%M:%S')).to eq('04:59:30')
    end
  end

  context 'when limited club rights' do
    let(:limited_club) { 'SS' }

    context 'and the csv file contains a different club' do
      before do
        @ci = CsvImport.new(@race, test_file_path('import_valid.csv'), limited_club)
      end

      it_should_behave_like 'failed import', 1

      it 'the error message should contain the valid club name' do
        expect(@ci.errors[0]).to eq("Sinulla on oikeus lisätä kilpailijoita vain \"#{limited_club}\"-piiriin")
      end
    end

    context 'and the csv file contains only the allowed club' do
      before do
        @ci = CsvImport.new(@race, test_file_path('import_valid_limited_club.csv'), limited_club)
      end

      it "#errors should be empty" do
        expect(@ci.errors.size).to eq(0)
      end
    end
  end

  context 'when semicolon is used as column separator' do
    before do
      @ci = CsvImport.new@race, test_file_path('import_valid_semicolon.csv')
    end

    it 'should accept valid file' do
      expect(@ci.save).to be_truthy
    end
  end

  context 'when the end the file contains empty rows' do
    before do
      @ci = CsvImport.new@race, test_file_path('import_valid_with_empty_rows.csv')
    end

    it 'should accept valid file' do
      expect(@ci.save).to be_truthy
    end
  end

  context 'when shooting race' do
    before do
      create :competitor, series: @series, number: 1
      create :competitor, series: @series, number: 4
      @race.update_attribute :sport_key, Sport::ILMAHIRVI
      @ci = CsvImport.new@race, test_file_path('import_valid.csv')
    end

    it 'adds automatically numbers for competitors' do
      expect(@ci.save).to be_truthy
      expect(@race.reload.competitors.size).to eq(2 + 5)
      expect(@race.competitors.find_by_number(2).first_name).to eql 'Heikki'
      expect(@race.competitors.find_by_number(3).first_name).to eql 'Minna'
      expect(@race.competitors.find_by_number(5).first_name).to eql 'Maija'
      expect(@race.competitors.find_by_number(6).first_name).to eql 'Minna'
      expect(@race.competitors.find_by_number(7).first_name).to eql 'Topi'
    end
  end

  def test_file_path(file_name)
    File.join(Rails.root, 'spec', 'files', file_name)
  end

  def expect_competitor(competitor, first_name, last_name, club_name, series_name, age_group_name = nil)
    expect(competitor.first_name).to eq first_name
    expect(competitor.last_name).to eq last_name
    expect(competitor.club.name).to eq club_name
    expect(competitor.series.name).to eq series_name
    if age_group_name
      expect(competitor.age_group.name).to eq age_group_name
    else
      expect(competitor.age_group).to be_nil
    end
  end
end
