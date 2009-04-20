When /^I join a group without paying dues$/ do
  @group.memberships.create!(:user => @user, :interest => false)
end

Then /^I am a member without voting interest$/ do
  @group.memberships.count.should == 1
  @group.memberships.voters.count.should == 0
end

