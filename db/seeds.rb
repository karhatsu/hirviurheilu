run = Sport.create!(:name => "Hirvenjuoksu", :key => "RUN")
ski = Sport.create!(:name => "Hirvenhiihto", :key => "SKI")

contest1 = run.contests.build(:name => "P-Savon hirvenjuoksukisat",
  :location => "Tervo", :start_date => '2010-08-14')
contest1.save!
contest2 = ski.contests.build(:name => "P-Savon hirvenhiihtokisat",
  :location => "Karttula", :start_date => '2010-12-13')
contest2.save!

s1 = contest1.series.build(:name => "Miehet yli 50v")
s1.save!

10.times do |i|
  club = Club.create!(:name => "Piiri #{i}")
  comp = s1.competitors.build(:first_name => "First #{i}", :last_name => "Last #{i}",
    :year_of_birth => 1960 + i, :club => club, :estimate1 => 100 - i, :estimate2 => 140 + i,
    :shots_total_input => 80 + i, :start_time => "14:#{i}", :arrival_time => "15:1#{i}")
  comp.save!
end