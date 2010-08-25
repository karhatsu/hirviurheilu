# roles, users
Role.create!(:name => Role::ADMIN)
Role.create!(:name => Role::OFFICIAL)

admin = User.create!(:email => 'admin@admin.com', :password => 'admin',
  :password_confirmation => 'admin', :first_name => 'Antti', :last_name => 'Admin')
admin.add_admin_rights

official1 = User.create!(:email => 'official1@official1.com', :password => 'official1',
  :password_confirmation => 'official1', :first_name => 'Timo', :last_name => 'Toimitsija')
official1.add_official_rights
official2 = User.create!(:email => 'official2@official2.com', :password => 'official2',
  :password_confirmation => 'official2', :first_name => 'Taina', :last_name => 'Toimitsijatar')
official2.add_official_rights

# sports
run = Sport.create!(:name => "Hirvenjuoksu", :key => "RUN")
ski = Sport.create!(:name => "Hirvenhiihto", :key => "SKI")

# clubs
clubs = []
10.times do |i|
  club_places = ["Vähälän", "Jokikylän", "Keski-Suomen", "Etelä-Savon", "Metsälän"]
  club_suffixes = ["piiri", "ampumaseura", "ammuntayhdistys"]
  club_name = "#{club_places[i % club_places.length]} #{club_suffixes[i % club_suffixes.length]}"
  clubs << Club.create!(:name => club_name)
end

# races
race1 = run.races.build(:name => "P-Savon hirvenjuoksukisat",
  :location => "Tervo", :start_date => '2010-08-14', :start_interval_seconds => 30)
race1.save!
official1.races << race1

race2 = ski.races.build(:name => "P-Savon hirvenhiihtokisat",
  :location => "Karttula", :start_date => '2010-12-13', :start_interval_seconds => 60)
race2.save!
official2.races << race2

# series
series_names = ["Yleinen", "M30", "M40", "M50", "M60"]
5.times do |series_i|
  correct1 = 100 + 5 * series_i
  correct2 = 160 - 5 * series_i
  series = race1.series.build(:name => series_names[series_i], :correct_estimate1 => correct1,
    :correct_estimate2 => correct2, :start_time => "2010-08-14 1#{series_i}:30",
    :first_number => 100)
  series.save!

  # competitors
  firsts = ["Matti", "Teppo", "Pekka", "Timo", "Jouni", "Heikki"]
  lasts = ["Heikkinen", "Räsänen", "Miettinen", "Savolainen", "Raitala"]
  10.times do |i|
    first = firsts[i % firsts.length]
    last = lasts[i % lasts.length]
    comp = series.competitors.build(:first_name => first, :last_name => last,
      :club => clubs[i], :number => 100 + i)
    if i % 4 == 0
      comp.shots << Shot.new(:competitor => comp, :value => 10)
      comp.shots << Shot.new(:competitor => comp, :value => 3)
      comp.shots << Shot.new(:competitor => comp, :value => 0)
      comp.shots << Shot.new(:competitor => comp, :value => 7)
      comp.shots << Shot.new(:competitor => comp, :value => 10)
      comp.shots << Shot.new(:competitor => comp, :value => 7)
      comp.shots << Shot.new(:competitor => comp, :value => 9)
      comp.shots << Shot.new(:competitor => comp, :value => 9)
      comp.shots << Shot.new(:competitor => comp, :value => 2)
      comp.shots << Shot.new(:competitor => comp, :value => 10)
    else
      shots = 71 + 2 * i
      shots = nil if i == 3 or i == 7
      comp.shots_total_input = shots
    end
    comp.estimate1 = correct1 + 6 - i
    comp.estimate2 = correct2 - 8 + 2 * 1
    if i == 1
      comp.estimate1 = nil
    elsif i == 3
      comp.estimate2 = nil
    elsif i == 6
      comp.estimate2 = correct2 + 1
    end
    comp.save!
  end

  comp = series.competitors.build(:first_name => 'Teemu', :last_name => 'Turkulainen',
    :club => clubs[2], :number => 110, :no_result_reason => Competitor::DNF)
  comp.save!

  unless series.generate_start_times
    raise series.errors.on(:base)
  end

  series.competitors.each_with_index do |comp, i|
    arrival = "15:0#{i + 1}:3#{9 - i}" unless i == 7
    comp.arrival_time = arrival
    comp.save!
  end
end