namespace :db do
  desc "Erase and fill users table"
  task :populate_users => :environment do
    
    [Invitation, User, Profile, Credit].each(&:delete_all)
 
      Invitation.create(:id=>'1', :email=>'foo@grantvote.com', :news=>'1', :sender_id=>'1', :sent_at=>Time.now)
      User.create!(:id=>'1', :login => "foo", :email => "foo@grantvote.com", :points => 44,
        :password => "pass", :password_confirmation => "pass", :invitation_id=>'1', :invitation_limit=>'1000',
        :blitz_interest => false, :blitz_contributes => 0, :blitz_rewards => 0 )
     
      Profile.create!(:user_id => 1, :login => "foo")
      Credit.create!(:user_id => 1, :points => 44,
        :pebbles => 2, :beads => 2, :buttons => 1, :pens => 1)
    
      Invitation.create(:id=>'2', :email=>'bar1@grantvote.com', :news=>'1', :sender_id=>'1', :sent_at=>Time.now)
      User.create!(:id=>'2', :login => "bar", :email => "bar@grantvote.com", :points => 23,
                   :password => "pass", :password_confirmation => "pass",:invitation_id=>'2',
                   :blitz_interest => true, :blitz_contributes => 5, :blitz_rewards => 0 )
      
      Profile.create!(:user_id => 2, :login => "bar")
      Credit.create!(:user_id => 2, :points => 23,
        :pebbles => 2, :beads => 1, :buttons => 2)
    
      Invitation.create(:id=>'3',:email=>'baz1@grantvote.com', :news=>'0', :sender_id=>'1', :sent_at=>Time.now)
      User.create!(:id=>'3',:login => "baz", :email => "baz@grantvote.com", :points => 41,
                   :password => "pass", :password_confirmation => "pass",:invitation_id=>'3',
                   :blitz_interest => true, :blitz_contributes => 5, :blitz_rewards => 0 )
     
      Profile.create!(:user_id => 3, :login => "baz")
      Credit.create!(:user_id => 3, :points => 41,
        :pebbles => 2, :beads => 1, :buttons => 1, :pens => 1)
    
      Invitation.create(:id=>'4',:email=>'wii1@grantvote.com', :news=>'0', :sender_id=>'1', :sent_at=>Time.now)
      User.create!(:id=>'4',:login => "wii", :email => "wii@grantvote.com", :points => 17,
                   :password => "pass", :password_confirmation => "pass",:invitation_id=>'4',
                   :blitz_interest => true, :blitz_contributes => 5, :blitz_rewards => 0 )

      Profile.create!(:user_id => 4, :login => "wii")
      Credit.create!(:user_id => 4, :points => 17, 
        :pebbles => 2, :beads => 1, :buttons => 1, :shells => 1)
    
      Invitation.create(:id=>'5',:email=>'loo1@grantvote.com', :news=>'0', :sender_id=>'1', :sent_at=>Time.now)
      User.create!(:id=>'5',:login => "loo", :email => "loo@grantvote.com", :points => 26,
                   :password => "pass", :password_confirmation => "pass",:invitation_id=>'5',
                   :blitz_interest => true, :blitz_contributes => 5, :blitz_rewards => 0 )
 
      Profile.create!(:user_id => 5, :login => "loo")
      Credit.create!(:user_id => 5, :points => 26,
        :pebbles => 2, :beads => 2, :buttons => 1, :pearls => 1)
    
  end
end


