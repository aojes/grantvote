namespace :db do
  desc "Erase and fill users table"
  task :populate_users => :environment do
    
    [User, Profile, Credit].each(&:delete_all)

    User.create!(:login => "foo", :email => "foo@grantvote.com",
                   :password => "pass", :password_confirmation => "pass")
      Profile.create!(:user_id => 1, :login => "foo")
      Credit.create!(:user_id => 1, :pebbles => 1)
    
    User.create!(:login => "bar", :email => "bar@grantvote.com",
                   :password => "pass", :password_confirmation => "pass")
      Profile.create!(:user_id => 2, :login => "bar")
      Credit.create!(:user_id => 2, :pebbles => 1)
    
    User.create!(:login => "baz", :email => "baz@grantvote.com",
                   :password => "pass", :password_confirmation => "pass")
      Profile.create!(:user_id => 3, :login => "baz")
      Credit.create!(:user_id => 3, :pebbles => 1)
    
    User.create!(:login => "wii", :email => "wii@grantvote.com",
                   :password => "pass", :password_confirmation => "pass")
      Profile.create!(:user_id => 4, :login => "wii")
      Credit.create!(:user_id => 4, :pebbles => 1)
    
    User.create!(:login => "loo", :email => "loo@grantvote.com",
                   :password => "pass", :password_confirmation => "pass")
      Profile.create!(:user_id => 5, :login => "loo")
      Credit.create!(:user_id => 5, :pebbles => 1) 
    
  end
end


