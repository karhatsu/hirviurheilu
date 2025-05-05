Given "the series has a competitor" do
  @competitor = create(:competitor, :series => @series)
end

Given "the series has a competitor {int} {string} {string} from {string}" do |number, first_name, last_name, club_name|
  club = Club.find_or_create_by race: @race, name: club_name
  @competitor = create :competitor, series: @series, club: club, number: number, first_name: first_name, last_name: last_name
end

Given "the series has a competitor {string} {string}" do |first_name, last_name|
  club = @race.clubs.first || create(:club, race: @race)
  @competitor = create(:competitor, series: @series, first_name: first_name, last_name: last_name, club: club)
end

Given("the series has a competitor with shots {string}") do |shots|
  @competitor = create :competitor, series: @series, shots: shots.split(',')
end

Given("the series has a competitor {int} {string} {string} from {string} with shots {string}") do |number, first_name, last_name, club_name, shots|
  club = Club.find_or_create_by race: @race, name: club_name
  @competitor = create :competitor, series: @series, club: club, number: number, first_name: first_name, last_name: last_name, shots: shots.split(',')
end

Given /^the series has a competitor "([^"]*)" "([^"]*)" with (\d+)\+(\d+)\+(\d+) points$/ do |first_name, last_name, tpoints, epoints, spoints|
  best_time = 600
  seconds_lost = (300 - tpoints.to_i) * 10
  @competitor = create(:competitor, :series => @series, :first_name => first_name, :last_name => last_name,
    :start_time => @series.start_time, :arrival_time => @series.start_time + best_time - seconds_lost,
    :estimate1 => 100, :correct_estimate1 => 100,
    :estimate2 => 150, :correct_estimate2 => 150 - (300 - epoints.to_i) / 2,
    :shooting_score_input => 100 - (600 - spoints.to_i) / 6)
  @competitor.estimate_points.should == epoints.to_i
  @competitor.shooting_points.should == spoints.to_i
end

Given('the series has a competitor {string} {string} with qualification round result {int}') do |first_name, last_name, qualification_round_score|
  @competitor = create :competitor, series: @series, first_name: first_name, last_name: last_name, qualification_round_shooting_score_input: qualification_round_score
end

Given('the series has a competitor {string} {string} from {string} with nordic results {int}, {int}, {int}, {int}') do |first_name, last_name, club_name, trap_score, shotgun_score, rifle_moving_score, rifle_standing_score|
  @club = Club.find_or_create_by! name: club_name, race: @race
  @competitor = create :competitor, series: @series, club: @club, first_name: first_name, last_name: last_name,
                       nordic_trap_score_input: trap_score, nordic_shotgun_score_input: shotgun_score,
                       nordic_rifle_moving_score_input: rifle_moving_score, nordic_rifle_standing_score_input: rifle_standing_score
end

Given('the series has a competitor {string} {string} from {string} with european results {int}, {int}, {int}, {int}, {int}, {int}') do |first_name, last_name, club_name, trap_score, compak_score, rifle1_score, rifle2_score, rifle3_score, rifle4_score|
  @club = Club.find_or_create_by! name: club_name, race: @race
  @competitor = create :competitor, series: @series, club: @club, first_name: first_name, last_name: last_name,
                       european_trap_score_input: trap_score, european_compak_score_input: compak_score,
                       european_rifle1_score_input: rifle1_score, european_rifle2_score_input: rifle2_score,
                       european_rifle3_score_input: rifle3_score, european_rifle4_score_input: rifle4_score
end

Given('the series has a competitor {string} {string} from {string} with european double results {int}+{int}, {int}+{int}, {int}+{int}, {int}+{int}, {int}+{int}, {int}+{int}') do |first_name, last_name, club_name, trap1, trap2, compak1, compak2, rifle1_1, rifle1_2, rifle2_1, rifle2_2, rifle3_1, rifle3_2, rifle4_1, rifle4_2|
  @club = Club.find_or_create_by! name: club_name, race: @race
  @competitor = create :competitor, series: @series, club: @club, first_name: first_name, last_name: last_name,
                       european_trap_score_input: trap1, european_trap_score_input2: trap2,
                       european_compak_score_input: compak1, european_compak_score_input2: compak2,
                       european_rifle1_score_input: rifle1_1, european_rifle1_score_input2: rifle1_2,
                       european_rifle2_score_input: rifle2_1, european_rifle2_score_input2: rifle2_2,
                       european_rifle3_score_input: rifle3_1, european_rifle3_score_input2: rifle3_2,
                       european_rifle4_score_input: rifle4_1, european_rifle4_score_input2: rifle4_2
end


Given /^the series has a competitor with attributes:$/ do |fields|
  hash = fields.rows_hash
  if hash[:club]
    club = Club.find_by_name(hash[:club])
    hash[:club_id] = club.id
    hash.delete "club" # workaround for ruby 1.9
  end
  if hash[:qualification_round_heat]
    heat = QualificationRoundHeat.where(race: @race.id, number: hash[:qualification_round_heat]).first
    hash[:qualification_round_heat_id] = heat.id
    hash.delete "qualification_round_heat"
  end
  if hash[:final_round_heat]
    heat = FinalRoundHeat.where(race: @race.id, number: hash[:final_round_heat]).first
    hash[:final_round_heat_id] = heat.id
    hash.delete "final_round_heat"
  end
  @competitor = create(:competitor, {:series => @series}.merge(hash))
end

Given /^the series "([^"]*)" contains a competitor with attributes:$/ do |series_name, fields|
  @series = Series.find_by_name(series_name)
  hash = fields.rows_hash
  if hash[:club]
    club = Club.find_by_name(hash[:club])
    club = Club.create!(:race => @series.race, :name => hash[:club]) unless club
    hash[:club] = club
    hash.delete "club" # workaround for ruby 1.9
  end
  @competitor = create(:competitor, {:series => @series}.merge(hash))
end

Given /^the competitor belongs to an age group "([^"]*)"$/ do |age_group_name|
  @competitor.age_group = AgeGroup.find_by_name(age_group_name)
  @competitor.save!
end

Given /^the competitor "([^"]*)" "([^"]*)" has the following results:$/ do |first_name,
    last_name, fields|
  competitor = Competitor.where(['first_name=? and last_name=?', first_name, last_name]).first
  competitor.attributes = fields.rows_hash
  competitor.save!
end

Given('the competitor has QR shooting rules penalty of {int}') do |penalty|
  @competitor.update_attribute :shooting_rules_penalty_qr, penalty
end

Given('the competitor has shooting rules penalty of {int}') do |penalty|
  @competitor.update_attribute :shooting_rules_penalty, penalty
end

Given /^someone else saves estimates (\d+) and (\d+) for the competitor$/ do |estimate1, estimate2|
  @competitor.reload
  @competitor.estimate1 = estimate1
  @competitor.estimate2 = estimate2
  @competitor.save!
end

When(/^I update the first competitor values to "(.*?)"\/"(.*?)", "(.*?)", "(.*?)", "(.*?)", "(.*?)", (\d+) in start list page$/) do |series_name,
    age_group_name, first_name, last_name, club_name, start_time, number|
  within(:xpath, "//div[@class='competitor_row'][2]") do
    select series_name, from: "competitor_#{@competitor.id}_competitor_series_id"
    select age_group_name, from: 'competitor[age_group_id]'
    fill_in "competitor_#{@competitor.id}_competitor_first_name", with: first_name
    fill_in "competitor_#{@competitor.id}_competitor_last_name", with: last_name
    fill_in "competitor_#{@competitor.id}_competitor_start_time", with: start_time
    fill_in "competitor_#{@competitor.id}_competitor_number", with: number
    fill_in "club_name_#{@competitor.id}", with: club_name
  end
end

Then("I should see competitor {int} {string} with start time {string} in card {int}") do |number, name, start_time, card|
  parent = "//a[@class='card']"
  find(:xpath, "(#{parent})[#{card}]//div[@class='card__number']").should have_text(number)
  find(:xpath, "(#{parent})[#{card}]//div[@class='card__name']").should have_text(name)
  find(:xpath, "(#{parent})[#{card}]//div[@class='card__middle-row'][2]").should have_text(start_time)
end
