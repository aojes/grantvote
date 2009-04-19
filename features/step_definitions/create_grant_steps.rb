Given /^I am a voting member of the group$/ do
  @user.login.should == 'foo'
end

