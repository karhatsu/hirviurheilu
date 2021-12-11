require 'spec_helper'

describe CsvMultipleImport do
  let(:user) { create :user, email: 'toimitsija.2@testi.com' }
  let!(:race_official) { create :user, email: 'toimitsija.1@testi.com' }

  before do
    District.create! short_name: 'LA', name: 'Lappi'
    District.create! short_name: 'PS', name: 'Pohjois-Savo'
  end

  context 'when valid file' do
    before do
      @import = CsvMultipleImport.new user, test_file_path('import_multiple_races.csv')
    end

    it 'succeeds' do
      expect(@import.errors).to eql []
    end

    it 'adds the races' do
      expect(Race.count).to eql 3
      race = Race.first
      expect(race.sport_key).to eql Sport::METSASTYSLUODIKKO
      expect(race.name).to eql 'Metsästysluodikon pm-kisat'
      expect(race.start_date.strftime('%d.%m.%Y')).to eql '25.11.2021'
      expect(race.location).to eql 'Testikylä'
      expect(race.address).to eql 'Ampurata 4, 99999 Testilä'
      expect(race.organizer).to eql 'Testikylän AS'
      expect(race.level).to eql 1
      expect(race.district.short_name).to eql 'PS'
    end

    it 'assigns the races to the user and to the official mentioned in the file' do
      race = Race.find_by_name 'Metsästysluodikon pm-kisat'
      expect(race.users.count).to eql 2
    end

    it 'does not assigns the race to the same user twice' do
      race = Race.find_by_name 'Testiseuran mestaruuskisat'
      expect(race.users.count).to eql 1
    end

    it 'sets official pending email when unknown email' do
      race = Race.find_by_name 'Ilmahirven seurakilpailut'
      expect(race.pending_official_email).to eql 'uusi@toimitsija.com'
      expect(race.users.count).to eql 1
    end

    context 'and same file is imported again' do
      before do
        @import = CsvMultipleImport.new user, test_file_path('import_multiple_races.csv')
      end

      it 'returns errors and does not add duplicate races' do
        expect(Race.count).to eql 3
        expected_errors = [
          { row: 2, errors: ['Järjestelmästä löytyy jo kilpailu, jolla on sama nimi, sijainti ja päivämäärä'] },
          { row: 3, errors: ['Järjestelmästä löytyy jo kilpailu, jolla on sama nimi, sijainti ja päivämäärä'] },
          { row: 4, errors: ['Järjestelmästä löytyy jo kilpailu, jolla on sama nimi, sijainti ja päivämäärä'] },
        ]
        expect(@import.errors).to eql expected_errors
      end
    end
  end

  context 'when invalid data in the file' do
    before do
      @import = CsvMultipleImport.new user, test_file_path('import_multiple_races_invalid.csv')
    end

    it 'returns errors and does not add any races' do
      expect(Race.count).to eql 0
      expected_errors = [
        { row: 3, errors: ['Piiri on virheellinen', 'Alkupvm on pakollinen', 'Taso on virheellinen', 'Toimitsijan sähköposti on pakollinen'] },
        { row: 4, errors: ['Laji on virheellinen', 'Paikkakunta on pakollinen', 'Toimitsijan sähköposti on kelvoton'] },
      ]
      expect(@import.errors).to eql expected_errors
    end
  end

  context 'when the file cannot be opened' do
    it 'returns error' do
      @import = CsvMultipleImport.new user, test_file_path('import_multiple_races.numbers')
      expect(@import.errors).to eql [{ row: 0, errors: ['Tiedosto on virheellinen'] }]
    end
  end

  context 'when wrong amount of columns' do
    it 'returns error' do
      @import = CsvMultipleImport.new user, test_file_path('import_multiple_races_wrong_columns.csv')
      expect(@import.errors).to eql [{ row: 0, errors: ['Virheellinen määrä sarakkeita'] }]
    end
  end

  def test_file_path(file_name)
    File.join(Rails.root, 'spec', 'files', file_name)
  end
end
