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
end