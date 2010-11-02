Then /^the admin should receive (an|no|\d+) emails?$/ do |amount|
  unread_emails_for(ADMIN_EMAIL).size.should == parse_email_count(amount)
end