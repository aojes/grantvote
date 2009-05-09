namespace :db do
  desc "Erase and fill users table"
  task :populate_users => :environment do
    
    [User, Profile, Credit].each(&:delete_all)

    User.create!(:login => "foo", :email => "foo@grantvote.com",
                   :password => "pass", :password_confirmation => "pass")
      Profile.create!(:user_id => 1, :login => "foo")
      Credit.create!(:user_id => 1, :points => 44, 
        :pebbles => 2, :beads => 2, :buttons => 1, :pens => 1)
    
    User.create!(:login => "bar", :email => "bar@grantvote.com",
                   :password => "pass", :password_confirmation => "pass")
      Profile.create!(:user_id => 2, :login => "bar")
      Credit.create!(:user_id => 2, :points => 23, 
        :pebbles => 2, :beads => 1, :buttons => 2)
    
    User.create!(:login => "baz", :email => "baz@grantvote.com",
                   :password => "pass", :password_confirmation => "pass")
      Profile.create!(:user_id => 3, :login => "baz")
      Credit.create!(:user_id => 3, :points => 41, 
        :pebbles => 2, :beads => 1, :buttons => 1, :pens => 1)
    
    User.create!(:login => "wii", :email => "wii@grantvote.com",
                   :password => "pass", :password_confirmation => "pass")
      Profile.create!(:user_id => 4, :login => "wii")
      Credit.create!(:user_id => 4, :points => 17, 
        :pebbles => 2, :beads => 1, :buttons => 1, :shells => 1)
    
    User.create!(:login => "lou", :email => "lou@grantvote.com",
                   :password => "pass", :password_confirmation => "pass")
      Profile.create!(:user_id => 5, :login => "loo")
      Credit.create!(:user_id => 5, :points => 26, 
        :pebbles => 2, :beads => 2, :buttons => 1, :pearls => 1)
    
  end
end


