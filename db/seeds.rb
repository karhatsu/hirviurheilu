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
  arrival = "15:0#{i + 1}" unless i == 7
  comp = s1.competitors.build(:first_name => first, :last_name => last,
    :year_of_birth => 1960 + i, :club => club,
    :estimate1 => correct1 - i, :estimate2 => correct2 + 2 * i,
    :start_time => '14:00', :arrival_time => arrival)
  if i % 4 == 0
    comp.shot1 = 10
    comp.shot2 = 3
    comp.shot3 = 0
    comp.shot4 = 7
    comp.shot5 = 10
    comp.shot6 = 7
    comp.shot7 = 9
    comp.shot8 = 9
    comp.shot9 = 2
    comp.shot10 = 10
  else
    shots = 70 + 2 * i
    shots = nil if i == 4 or i == 7
    comp.shots_total_input = shots
  end
  comp.save!
end