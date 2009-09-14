namespace :db do
  desc "Erase and fill users table"
  task :populate_users => :environment do

    [User, Profile, Credit, Friendship].each(&:delete_all)

    #Invitation.create(:id=>'1', :email=>'foo@grantvote.com', :news=>'1', :sender_id=>'1', :sent_at=>Time.now)
    foo = User.create!(:login => "foo", :email => "foo@grantvote.com", :points => 12,
      :password => "pass", :password_confirmation => "pass",
      :blitz_interest => false, :blitz_contributes => 0, :blitz_rewards => 0 )
    Profile.create!(:user_id => User.find_by_login("foo").id, :login => "foo")
    Credit.create!(:user_id => User.find_by_login("foo").id, :points => 12,
      :beads => 1, :buttons => 1)

    #Invitation.create(:id=>'2', :email=>'bar1@grantvote.com', :news=>'1', :sender_id=>'1', :sent_at=>Time.now)
    bar = User.create!(:login => "bar", :email => "bar@grantvote.com", :points => 12,
                  :password => "pass", :password_confirmation => "pass",
                  :blitz_interest => false, :blitz_contributes => 0, :blitz_rewards => 0 )
    Profile.create!(:user_id => User.find_by_login("bar").id, :login => "bar")
    Credit.create!(:user_id => User.find_by_login("bar").id, :points => 12,
      :beads => 1, :buttons => 1)

    #Invitation.create(:id=>'3',:email=>'baz1@grantvote.com', :news=>'0', :sender_id=>'1', :sent_at=>Time.now)
    baz = User.create!(:login => "baz", :email => "baz@grantvote.com", :points => 12,
                  :password => "pass", :password_confirmation => "pass",
                  :blitz_interest => false, :blitz_contributes => 5, :blitz_rewards => 20 )
    Profile.create!(:user_id => User.find_by_login("baz").id, :login => "baz")
    Credit.create!(:user_id => User.find_by_login("baz").id, :points => 12,
      :beads => 1, :buttons => 1)

    #Invitation.create(:id=>'4',:email=>'wii1@grantvote.com', :news=>'0', :sender_id=>'1', :sent_at=>Time.now)
    wii = User.create!(:login => "wii", :email => "wii@grantvote.com", :points => 17,
                  :password => "pass", :password_confirmation => "pass",
                  :blitz_interest => false, :blitz_contributes => 5, :blitz_rewards => 20 )
    Profile.create!(:user_id => User.find_by_login("wii").id, :login => "wii")
    Credit.create!(:user_id => User.find_by_login("wii").id, :points => 17,
      :pebbles => 2, :beads => 1, :buttons => 1, :shells => 1)

    #Invitation.create(:id=>'5',:email=>'loo1@grantvote.com', :news=>'0', :sender_id=>'1', :sent_at=>Time.now)
    loo = User.create!(:login => "loo", :email => "loo@grantvote.com", :points => 26,
                  :password => "pass", :password_confirmation => "pass",
                  :blitz_interest => false, :blitz_contributes => 0, :blitz_rewards => 0 )
    Profile.create!(:user_id => User.find_by_login("loo").id, :login => "loo")
    Credit.create!(:user_id => User.find_by_login("loo").id, :points => 26,
      :pebbles => 2, :beads => 2, :buttons => 1, :pearls => 1)


    Friendship.create!(:user_id => foo.id, :friend_id => bar.id)
    Friendship.create!(:user_id => foo.id, :friend_id => baz.id)

    Friendship.create!(:user_id => bar.id, :friend_id => foo.id)
    Friendship.create!(:user_id => bar.id, :friend_id => baz.id)

    Friendship.create!(:user_id => baz.id, :friend_id => foo.id)
    Friendship.create!(:user_id => baz.id, :friend_id => bar.id)

    Friendship.create!(:user_id => wii.id, :friend_id => loo.id)
    Friendship.create!(:user_id => loo.id, :friend_id => wii.id)
  end
end

