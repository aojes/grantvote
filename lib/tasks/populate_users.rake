namespace :db do
  desc "Erase and fill users table"
  task :populate_users => :environment do
    
    [User, Profile].each(&:delete_all)

    User.create!(:login => "foo", :email => "foo@grantvote.com",
                   :password => "pass", :password_confirmation => "pass")
      Profile.create!(:user_id => 1, :login => "foo")
    
    User.create!(:login => "bar", :email => "bar@grantvote.com",
                   :password => "pass", :password_confirmation => "pass")
      Profile.create!(:user_id => 2, :login => "bar")
    
    User.create!(:login => "baz", :email => "baz@grantvote.com",
                   :password => "pass", :password_confirmation => "pass")
      Profile.create!(:user_id => 3, :login => "baz") 
    
  end
end


