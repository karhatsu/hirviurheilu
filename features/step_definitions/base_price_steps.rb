Given /^there is a base price (\d+)$/ do |price|
  Factory.create(:base_price, :price => price)
end
