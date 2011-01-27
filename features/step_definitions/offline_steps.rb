Given /^I use the software offline$/ do
  Mode.stub!(:offline?).and_return(true)
  Mode.stub!(:online?).and_return(false)
end
