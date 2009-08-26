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

Then /^I should see my avatar by the comment$/ do
  response.should have_selector("img")
end

Then /^I should be able to delete the comment$/ do
  response.should contain("delete")
  click_link("delete")
  response.should be_success
  response.should_not contain("basic update")
end

Given /^my friend has posted an update$/ do
  @update = User.find_by_login('bar').communications.
                                        create!(:content => 'hello friends!')
  @update.content.should == 'hello friends!'
  @update.user.login.should == 'bar'
#  !@friend.friendships.find(User.find_by_login('foo').id).nil?
#  !@user.friendships.find(User.find_by_login('bar').id).nil?
end

Then /^I should see my friends update on my homepage$/ do
  visit '/home'
  response.should contain('hello friends!')
end

And /^I should not be able to delete my friends update$/ do

end

