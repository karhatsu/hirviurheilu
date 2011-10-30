require 'rubygems'

# Set up gems listed in the Gemfile.
is_windows = (RUBY_PLATFORM =~ /mswin|mingw/)
gemfile_name = is_windows ? "Gemfile-windows" : "Gemfile"
gemfile = File.expand_path("../../#{gemfile_name}", __FILE__)
begin
  ENV['BUNDLE_GEMFILE'] = gemfile
  require 'bundler'
  Bundler.setup
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end if File.exist?(gemfile)
