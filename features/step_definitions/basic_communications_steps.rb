Given /^I am logged in$/ do
  visit '/home'
  response.should contain("You")
end

When /^I enter some text$/ do
  fill_in "communication[content]", :with => "basic update"
end

Then /^I press Update$/ do
  click_button "Update"
end

Then /^I should see my comment on the page$/ do
  response.should contain("basic update")
end

