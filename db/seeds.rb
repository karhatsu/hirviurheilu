
# roles, users
Role.create_roles

admin = User.create!(:email => 'admin@admin.com', :password => 'admin',
  :password_confirmation => 'admin', :first_name => 'Antti', :last_name => 'Admin')
admin.add_admin_rights

official1 = User.create!(:email => 'official1@official1.com', :password => 'official1',
  :password_confirmation => 'official1', :first_name => 'Timo', :last_name => 'Toimitsija')
official1.add_official_rights
official2 = User.create!(:email => 'official2@official2.com', :password => 'official2',
  :password_confirmation => 'official2', :first_name => 'Taina', :last_name => 'Toimitsijatar')
official2.add_official_rights

# races
race2 = ski.races.build(:name => "P-Savon hirvenhiihtokisat",
  :location => "Karttula", :start_date => '2010-12-13', :start_interval_seconds => 60)
race2.save!
official2.add_race(race2)

race_titles = ['P-Savon hirvenjuoksukisat', 'Hirvenjuoksupeijaiset',
  'Joensuun syyskisat', 'Hirvenhiihtokauden avajaiskilpailut',
  'Pitkämäen SM-katsastukset', 'Vehmersalmen SM-katsastukset', 'SM2011']
race_locations = ["Tervo", "Heinävesi", "Joensuu", "Rymättylä", "Pitkämäki", "Vehmersalmi", "Ii"]
race_start_dates = ['2010-07-14', '2010-08-11', '2010-09-03', '2010-09-22',
  '2010-12-18', '2011-01-06', '2011-01-18']
race_end_dates = [nil, '2010-08-29', nil, nil, nil, '2011-01-07', nil]
7.times do |race_i|
  sport_key = (race_i < 4 ? Sport::RUN : Sport::SKI)
  interval = (race_i % 2 == 0 ? 30 : 60)
  race = Race.create!(sport_key: sport_key, :name => race_titles[race_i],
    :location => race_locations[race_i], :start_date => race_start_dates[race_i],
    :end_date => race_end_dates[race_i], :start_interval_seconds => interval)
  official1.add_race(race)
  correct1 = 100 + 5 * race_i
  correct2 = 160 - 5 * race_i

  old_race = race.end_date < Date.today

  # clubs
  clubs = []
  10.times do |i|
    club_places = ["Vähälän", "Jokikylän", "Keski-Suomen", "Etelä-Savon", "Metsälän"]
    club_suffixes = ["piiri", "ampumaseura", "ammuntayhdistys"]
    club_name = "#{club_places[i % club_places.length]} #{club_suffixes[i % club_suffixes.length]}"
    clubs << Club.create!(:race => race, :name => club_name)
  end

  # series
  series_names = ["M", "M40", "M50", "M60", "M70"]
  5.times do |series_i|
    series = race.series.build(:name => series_names[series_i],
      :start_time => "#{race_start_dates[race_i]} 1#{series_i}:10",
      :first_number => 20 * series_i + 1)
    series.save!

    if series.name == "M60"
      series.age_groups << AgeGroup.new(:name => "M65")
    elsif series.name == "M70"
      series.age_groups << AgeGroup.new(:name => "M75")
      series.age_groups << AgeGroup.new(:name => "M80")
    end

    # competitors
    if race_i < 3
      firsts = ["Matti", "Teppo", "Pekka", "Timo", "Jouni", "Heikki"]
      lasts = ["Heikkinen", "Räsänen", "Miettinen", "Savolainen", "Raitala"]
      competitors = []
      10.times do |i|
        first = firsts[i % firsts.length]
        last = lasts[i % lasts.length]
        comp = series.competitors.build(:first_name => first, :last_name => last,
          :club => clubs[i])
        unless series.age_groups.empty?
          if i % 3 == 0
            comp.age_group = series.age_groups.first
          elsif i % 7 == 0
            comp.age_group = series.age_groups.last
          end
        end
        comp.save!
        competitors << comp
      end
      series.generate_start_list!(Series::START_LIST_RANDOM)
      10.times do |i|
        comp = competitors[i]
        if race.start_date < Date.today
          if i % 4 == 0
            comp.shots ||= []
            comp.shots << i
          else
            shots = 71 + 2 * i
            shots = nil if (i == 3 or i == 7) and not old_race
            comp.shooting_score_input = shots
          end
          comp.estimate1 = correct1 + 6 - i
          comp.estimate2 = correct2 - 8 + 2 * 1
          if i == 1 and not old_race
            comp.estimate1 = nil
          elsif i == 3 and not old_race
            comp.estimate2 = nil
          elsif i == 6
            comp.estimate2 = correct2 + 1
          end
        end
        comp.save!
      end

      comp = series.competitors.build(:first_name => 'Teemu', :last_name => 'Turkulainen',
        :club => clubs[2], :number => series.next_start_number,
        :start_time => series.next_start_time, :no_result_reason => Competitor::DNF)
      comp.save!

      if old_race or race.start_date < Date.today
        series.competitors.each_with_index do |comp, i|
          arrival = "1#{series_i}:4#{(i + 1) % 10}:3#{9 - i}" if i != 7 or old_race
          comp.arrival_time = arrival
          comp.save!
        end
      end
    end
  end

  if old_race
    race.correct_estimates << CorrectEstimate.new(:race => race,
      :min_number => 1, :max_number => nil,
      :distance1 => correct1, :distance2 => correct2)
    race.set_correct_estimates_for_competitors
    race.finish!
  end
end
