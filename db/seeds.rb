run = Sport.create!(:name => "Hirvenjuoksu", :key => "RUN")
ski = Sport.create!(:name => "Hirvenhiihto", :key => "SKI")

race1 = run.races.build(:name => "P-Savon hirvenjuoksukisat",
  :location => "Tervo", :start_date => '2010-08-14')
race1.save!
race2 = ski.races.build(:name => "P-Savon hirvenhiihtokisat",
  :location => "Karttula", :start_date => '2010-12-13')
race2.save!

correct1 = 100
correct2 = 140
s1 = race1.series.build(:name => "Miehet yli 50v", :correct_estimate1 => correct1,
  :correct_estimate2 => correct2)
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
    :year_of_birth => 1960 + i, :club => club,
    :estimate1 => correct1 - i, :estimate2 => correct2 + 2 * i,
    :shots_total_input => shots, :start_time => '14:00', :arrival_time => arrival)
  comp.save!
end