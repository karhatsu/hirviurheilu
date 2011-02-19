Given /^I use the service in the (.*) environment$/ do |env|
  Rails.stub!(:env).and_return(env)
end
