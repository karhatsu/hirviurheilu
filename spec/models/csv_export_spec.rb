require 'spec_helper'
require 'digest'

GENERATED_FILE = 'spec/files/generated.csv'

describe CsvExport do
  before do
    @race = create(:race)
    club1 = create(:club, :name => 'Keski-Maan piiri')
    club2 = create(:club, :name => 'Uusi-Savo')
    series1 = create(:series, :name => 'M', :race => @race, :first_number => 10, :start_time => '12:00:30')
    series2 = create(:series, :name => 'N50', :race => @race, :first_number => 25, :start_time => '13:05:25')
    age_group2 = create(:age_group, :series => series2, :name => 'N60')
    series3 = create(:series, :name => 'M60', :race => @race)
    create(:competitor, :series => series1, :first_name => 'Mika', :last_name => 'Heikkinen', :club => club1)
    create(:competitor, :series => series2, :first_name => 'Maija', :last_name => 'Miettinen', :club => club2, :age_group => age_group2)
    create(:competitor, :series => series2, :first_name => 'Auli', :last_name => 'Ahtola', :club => club1, :age_group => age_group2, :team_name => 'Yotos team')
    create(:competitor, :series => series3, :first_name => 'Petteri', :last_name => 'Pehtola', :club => club1, :number => nil)
    series1.generate_start_list!(Series::START_LIST_ADDING_ORDER)
    series2.generate_start_list!(Series::START_LIST_ADDING_ORDER)
  end
  
  it "generates csv file with competitors ordered by start time" do
    CsvExport.new(@race).generate_file(GENERATED_FILE)
    verify_files_equal(GENERATED_FILE, 'spec/files/export.csv')
  end
  
  def verify_files_equal(generated, expected)
    expect(calculate_sha1(generated)).to eq(calculate_sha1(expected))
  end
  
  def calculate_sha1(file_name)
    sha1 = Digest::SHA1.new
    File.open(file_name) do |file|
      buffer = ''
      while not file.eof
        file.read(512, buffer)
        sha1.update(buffer)
      end
    end
    sha1.to_s
  end
end
