Given /^there is a base price (\d+)$/ do |price|
  FactoryGirl.create(:base_price, :price => price)
end
