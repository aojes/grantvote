namespace :db do
  desc "Erase and fill users table"
  task :populate_users => :environment do
    
    [Invitation, User, Profile, Credit].each(&:delete_all)
 
      Invitation.create(:id=>'1', :email=>'foo@grantvote.com', :news=>'1', :sender_id=>'1', :sent_at=>Time.now)
       User.create!(:id=>'1', :login => "foo", :email => "foo@grantvote.com",
                   :password => "pass", :password_confirmation => "pass", :invitation_id=>'1', :invitation_limit=>'1000' )
     
      Profile.create!(:user_id => 1, :login => "foo")
      Credit.create!(:user_id => 1, :points => 44, 
        :pebbles => 2, :beads => 2, :buttons => 1, :pens => 1)
    
      Invitation.create(:id=>'2', :email=>'bar1@grantvote.com', :news=>'1', :sender_id=>'1', :sent_at=>Time.now)
      User.create!(:id=>'2', :login => "bar", :email => "bar@grantvote.com",
                   :password => "pass", :password_confirmation => "pass",:invitation_id=>'2')
      
      Profile.create!(:user_id => 2, :login => "bar")
      Credit.create!(:user_id => 2, :points => 23, 
        :pebbles => 2, :beads => 1, :buttons => 2)
    
      Invitation.create(:id=>'3',:email=>'baz1@grantvote.com', :news=>'0', :sender_id=>'1', :sent_at=>Time.now)
      User.create!(:id=>'3',:login => "baz", :email => "baz@grantvote.com",
                   :password => "pass", :password_confirmation => "pass",:invitation_id=>'3')
     
      Profile.create!(:user_id => 3, :login => "baz")
      Credit.create!(:user_id => 3, :points => 41, 
        :pebbles => 2, :beads => 1, :buttons => 1, :pens => 1)
    
      Invitation.create(:id=>'4',:email=>'wii1@grantvote.com', :news=>'0', :sender_id=>'1', :sent_at=>Time.now)
      User.create!(:id=>'4',:login => "wii", :email => "wii@grantvote.com",
                   :password => "pass", :password_confirmation => "pass",:invitation_id=>'4')

      Profile.create!(:user_id => 4, :login => "wii")
      Credit.create!(:user_id => 4, :points => 17, 
        :pebbles => 2, :beads => 1, :buttons => 1, :shells => 1)
    
      Invitation.create(:id=>'5',:email=>'lou1@grantvote.com', :news=>'0', :sender_id=>'1', :sent_at=>Time.now)
      User.create!(:id=>'5',:login => "lou", :email => "lou@grantvote.com",
                   :password => "pass", :password_confirmation => "pass",:invitation_id=>'5')
 
      Profile.create!(:user_id => 5, :login => "loo")
      Credit.create!(:user_id => 5, :points => 26, 
        :pebbles => 2, :beads => 2, :buttons => 1, :pearls => 1)
    
  end
end


