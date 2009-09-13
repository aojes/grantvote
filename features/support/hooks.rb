Before('@login') do
  # This will only run before scenarios tagged above

#  Invitation.create!(:email=>'foo@grantvote.com',
#    :news => true, :sender_id => 1, :sent_at => Time.now)
  User.create!(:login => "foo", :email => "foo@grantvote.com",
    :points => 0, :password => "pass", :password_confirmation => "pass",
    :blitz_interest => false, :blitz_contributes => 0, :blitz_rewards => 0 )
  Profile.create!(:user_id => User.find_by_login('foo').id, :login => "foo")
  Credit.create!(:user_id => User.find_by_login('foo').id)

  visit '/login'
  fill_in('Login', :with => "foo")
  fill_in('Password', :with => "pass")
  click_button

  @user = User.find_by_login("foo")
end

Before('@friend') do
  # This will only run before scenarios tagged above

#  Invitation.create!(:email => 'bar@grantvote.com',
#    :news => true, :sender_id => 37, :sent_at => Time.now)
  User.create!(:login => "bar", :email => "bar@grantvote.com",
    :points => 0, :password => "pass", :password_confirmation => "pass",
    :blitz_interest => false, :blitz_contributes => 0, :blitz_rewards => 0 )
  Profile.create!(:user_id => User.find_by_login('bar').id, :login => "bar")
  Credit.create!(:user_id => User.find_by_login('bar').id)

  @friend = User.find_by_login("bar")

  @friend.friendships.create!(:user_id => User.find_by_login('foo').id)
  User.find_by_login('foo').friendships.create!(:user_id => User.find_by_login('bar').id)
end

Before('@user') do
#  Invitation.create!(:email=>'bar@grantvote.com',
#    :news => true, :sender_id => 37, :sent_at => Time.now)
  User.create!(:login => "foo", :email => "bar@grantvote.com",
    :points => 0, :password => "pass", :password_confirmation => "pass",
    :blitz_interest => false, :blitz_contributes => 0, :blitz_rewards => 0 )
  Profile.create!(:user_id => User.find_by_login('bar').id, :login => "bar")
  Credit.create!(:user_id => User.find_by_login('bar').id)

  @user = User.find_by_login('bar')
end

Before('@group') do
  @group = Group.create!(:name => "group", :purpose => "group purpose",
                    :dues => 3,
                    :photo_file_size => 1, :photo_content_type => 'image/png',
                    :photo_file_name => "photo.png")
end

Before('@voter') do
  @group = Group.create!(:name => "foobar", :purpose => "foobar", :dues => 2,
                    :photo_file_size => 1, :photo_content_type => 'image/png',
                    :photo_file_name => "photo.png")
  @group.memberships.create!(:user => @user, :interest => true)
end

Before('@grant') do
  @group.grants.create!(:user => @user, :name => "foobar", :amount => 20,
  :proposal => "foobar", :photo_file_size => 1,
      :photo_content_type => 'image/png', :photo_file_name => "photo.png")
end

