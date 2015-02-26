Given /^there is a base price (\d+)$/ do |price|
  create(:base_price, :price => price)
end
