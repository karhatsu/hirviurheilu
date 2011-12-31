Dir.chdir(File.dirname(__FILE__))
ENV["RAILS_ENV"] = "winoffline-prod"

p "TARKASTETAAN TIETOKANNAN TILA... (ole hyva ja odota)"
require File.expand_path('../config/application', __FILE__)
require 'rake'
ElkSports::Application.load_tasks
task = Rake::Task["db:migrate"]
task.invoke

p "KAYNNISTETAAN HIRVIURHEILU... (ole hyva ja odota)"
load 'script/rails'
