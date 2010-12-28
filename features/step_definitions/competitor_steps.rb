Given /^the series has a competitor$/ do
  @competitor = Factory.create(:competitor, :series => @series)
end

Given /^the series has a competitor with attributes:$/ do |fields|
  hash = fields.rows_hash
  if hash[:club]
    club = Club.find_by_name(hash[:club])
    hash[:club] = club
  end
  @competitor = Factory.create(:competitor, {:series => @series}.merge(hash))
end

Given /^the competitor "([^"]*)" "([^"]*)" has the following results:$/ do |first_name,
    last_name, fields|
  competitor = Competitor.where(['first_name=? and last_name=?', first_name, last_name]).first
  competitor.attributes = fields.rows_hash
  competitor.save!
end
