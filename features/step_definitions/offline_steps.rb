Given /^I use the software offline$/ do
  Mode.stub(:offline?).and_return(true)
  Mode.stub(:online?).and_return(false)
  visit '/' # this creates the user
  @user = User.first
end

Given /^I use the software online again$/ do
  Mode.unstub(:offline?)
  Mode.unstub(:online?)
  @user = nil
end
