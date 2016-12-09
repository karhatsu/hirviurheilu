When /^(?:I|they) click the first link in the email$/ do
  link = links_in_email(current_email).first
  visit request_uri(link.gsub("'", ''))
end

Then /^the admin should receive (an|no|\d+) emails?$/ do |amount|
  unread_emails_for(ADMIN_EMAIL).size.should == parse_email_count(amount)
end