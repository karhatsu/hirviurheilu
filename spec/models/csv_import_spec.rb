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
    @race = create(:race)
    series = build(:series, :race => @race, :name => 'N')
    @race.series << series
    series.age_groups << build(:age_group, :series => series, :name => 'N50')
    @race.series << build(:series, :race => @race, :name => 'M40')
    @race.clubs << build(:club, :race => @race, :name => 'PS')
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
            expect(@race.competitors.size).to eq(4)
            competitors = @race.competitors.except(:order).order('id')
            c = competitors[0]
            expect(c.first_name).to eq('Heikki')
            expect(c.last_name).to eq('Räsänen')
            expect(c.series.name).to eq('M40')
            expect(c.club.name).to eq('SS')
            c = competitors[1]
            expect(c.first_name).to eq('Minna')
            expect(c.last_name).to eq('Miettinen')
            expect(c.series.name).to eq('N')
            expect(c.age_group).to be_nil
            expect(c.club.name).to eq('PS')
            c = competitors[2]
            expect(c.first_name).to eq('Maija')
            expect(c.last_name).to eq('Hämäläinen')
            expect(c.series.name).to eq('N')
            expect(c.age_group.name).to eq('N50')
            expect(c.club.name).to eq('SS')
            c = competitors[3]
            expect(c.first_name).to eq('Minna')
            expect(c.last_name).to eq('Hämäläinen')
            expect(c.series.name).to eq('N')
            expect(c.age_group.name).to eq('N50')
            expect(c.club.name).to eq('SS')
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
            c = @race.competitors.order('id')[0]
            expect(c.first_name).to eq('Timo')
            expect(c.last_name).to eq('Malinen')
            expect(c.series.name).to eq('M40')
            expect(c.club.name).to eq('Ampumaseura')
            c = @race.competitors.order('id')[1]
            expect(c.first_name).to eq('Toni')
            expect(c.last_name).to eq('Miettinen')
            expect(c.series.name).to eq('M40')
            expect(c.club.name).to eq('Kuikan Erä')
            c = @race.competitors.order('id')[2]
            expect(c.first_name).to eq('Teppo')
            expect(c.last_name).to eq('Ylönen')
            expect(c.series.name).to eq('M40')
            expect(c.club.name).to eq('Sum Um')
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

      it "the error message should contain the errorneous row" do
        expect(@ci.errors[0]).to eq("Riviltä puuttuu tietoja: Minna,Miettinen,,N")
      end
    end

    context "when some column contains only spaces" do
      before do
        @ci = CsvImport.new(@race, test_file_path('import_with_spaces_in_column.csv'))
      end

      it_should_behave_like 'failed import', 1

      it "the error message should contain the errorneous row" do
        expect(@ci.errors[0]).to eq("Riviltä puuttuu tietoja: Minna,  ,PS,N")
      end
    end

    context "when the file contains two errorneous rows" do
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
    context 'and competitors imported without numbers' do
      before do
        @race.update_attribute :sport_key, Sport::ILMAHIRVI
        @ci = CsvImport.new@race, test_file_path('import_valid.csv')
      end

      it 'should accept the file' do
        expect(@ci.save).to be_truthy
        expect(@race.competitors.size).to eq(4)
      end
    end

    context 'and competitors imported with numbers' do
      before do
        @race.update_attribute :sport_key, Sport::ILMAHIRVI
        @ci = CsvImport.new@race, test_file_path('import_valid_with_numbers.csv')
      end

      it 'should accept the file' do
        expect(@ci.errors).to eq []
        expect(@ci.save).to be_truthy
        expect(@race.competitors.size).to eq(2)
        expect(@race.competitors.where('last_name=?', 'Miettinen').first.number).to eql 6
      end
    end
  end

  def test_file_path(file_name)
    File.join(Rails.root, 'spec', 'files', file_name)
  end
end
