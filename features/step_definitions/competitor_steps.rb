Given /^the series has a competitor with attributes:$/ do |fields|
  hash = fields.rows_hash
  if hash[:club]
    club = Club.find_by_name(hash[:club])
    hash[:club] = club
  end
  Factory.create(:competitor, {:series => @series}.merge(hash))
end
