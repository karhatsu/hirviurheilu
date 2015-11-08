Given /^I use the service in the production environment$/ do
  allow(ProductionEnvironment).to receive(:staging?).and_return(false)
  allow(ProductionEnvironment).to receive(:production?).and_return(true)
end

Given /^I use the service in the staging environment$/ do
  allow(ProductionEnvironment).to receive(:staging?).and_return(true)
  allow(ProductionEnvironment).to receive(:production?).and_return(false)
end
