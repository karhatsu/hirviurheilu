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

firsts = ["Matti", "Teppo", "Pekka", "Timo", "Jouni", "Heikki"]
lasts = ["Heikkinen", "Räsänen", "Miettinen", "Savolainen", "Raitala"]
10.times do |i|
  first = firsts[i % firsts.length]
  last = lasts[i % lasts.length]
  club = Club.create!(:name => "Piiri #{i}")
  shots = 70 + 2 * i
  shots = nil if i == 4 or i == 7
  arrival = "15:0#{i + 1}"
  comp = s1.competitors.build(:first_name => first, :last_name => last,
    :year_of_birth => 1960 + i, :club => club, :estimate1 => 100 - i, :estimate2 => 140 + 2 * i,
    :shots_total_input => shots, :start_time => '14:00', :arrival_time => arrival)
  comp.save!
end