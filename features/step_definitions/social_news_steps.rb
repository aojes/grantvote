Given /^I have a friend$/ do
  Invitation.create(:id => 2, :email => 'bar@grantvote.com', 
    :news => true, :sender_id => 37, :sent_at => Time.now)
  User.create!(:id => 2, :login => "bar", :email => "bar@grantvote.com", 
    :points => 1, :password => "pass", :password_confirmation => "pass", 
    :invitation_id => 2, :invitation_limit => 5, :blitz_interest => true, 
    :blitz_contributes => 10, :blitz_rewards => 0 )
  Profile.create!(:user_id => 2, :login => "bar")
  Credit.create!(:user_id => 2, :points => 1)  
  
  @user.friendships.create!(:friend_id => User.find_by_login('bar').id)
  User.find_by_login('bar').friendships.create!(:friend_id => User.find_by_login('foo').id)
  
  @user.friendships.count.should == 1
  User.find_by_login('bar').friendships.count.should == 1
    
end

Given /^my friend has a new blitz grant$/ do
  BlitzFund.create!(:dues => 3, :general_pool => 1000)
  User.find_by_login('bar').blitzes.create!(:name => "bar's new blitz grant",
    :proposal => "I need some money.", :votes_win => 2,
    :blitz_fund_id => BlitzFund.find_by_dues(3).id).
      votes.create!(:cast => 'yea', :group_id => 0, 
      :user_id => User.find_by_login('bar').id)
  Vote.all.count.should == 1
end

Then /^I should see an activity listing my friend's new blitz grant$/ do
  click_link "Home"
  response.should contain(/bar\s+created\s+(.+)/i)
end

Given /^my friend wins a blitz grant$/ do
  User.find_by_login('bar').blitzes.first.votes.create!(
    :cast => 'yea', :user_id => 27)
  
end

Then /^I should see an activitiy listing my friend's winning a blitz grant$/ do
  click_link "Home"
  response.should contain(/bar\s+won\s+(.+)/i)
end

Given /^my friend joins a group$/ do
  @group.memberships.create!(:user_id => User.find_by_login('bar').id,
    :interest => false)
  User.find_by_login('bar').groups.count.should == 1
end

Then /^I should see a listing for my friend joining the group$/ do
  click_link "Home"
  response.should contain(/bar\s+joined\s+(.+)/i)
end


