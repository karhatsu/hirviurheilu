Given /^I use the software offline$/ do
  Rails.stub!(:env).and_return('offline')
end
