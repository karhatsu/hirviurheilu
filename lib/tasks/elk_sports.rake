namespace :elk_sports do
  namespace :offline do
    task :check_env => :environment do
      abort 'This task is allowed to run only in offline mode' if Mode.online?
    end

    task :create_db => [:check_env, 'db:schema:load'] do
      Role.create_roles
      Sport.create_run
      Sport.create_ski
      DefaultSeries.create_default_series
    end
  end

  namespace :data do
    task :relays => :environment do
      race = Race.last
      relay = Relay.new(:name => 'Data test relay', :start_time => '13:00',
        :start_day => 1, :legs_count => 4)
      race.relays << relay
      20.times do |i|
        team = RelayTeam.new(:name => "Test team #{i + 1}", :number => i + 1)
        relay.relay_teams << team
        4.times do |j|
          competitor = RelayCompetitor.new(:leg => j + 1, :first_name => "Tom",
            :last_name => "Test #{j + 1}", :misses => j, :estimate => 100 - j,
            :arrival_time => "13:#{j+1}6")
          competitor.adjustment = 75 if i * j == 6
          team.relay_competitors << competitor
        end
      end
      4.times do |i|
        relay.relay_correct_estimates << RelayCorrectEstimate.new(:leg => i + 1,
          :distance => 90)
      end
    end
  end
end