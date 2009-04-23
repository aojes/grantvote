Given /^I am on my account page$/ do
  visit account_path
end

Given /^I click the buttons to create and maintain a public profile$/ do
  click_button "Edit"
  click_link "Profile"
end

When /^I have entered my full name$/ do
  pending #fill_in "Full name", :with => "Jesse Crockett"
end

When /^I have entered my text bio$/ do
  pending
end

When /^I have entered a primary link$/ do
  pending
end

When /^I have entered my location$/ do
  pending
end

When /^I press Create$/ do
  pending
end

Then /^I should be on the public profile page$/ do
  pending
end

Then /^I should see Profile create successfully$/ do
  pending
end

