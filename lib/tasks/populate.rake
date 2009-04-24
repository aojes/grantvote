namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    
    [Group, Membership, Grant, Vote].each(&:delete_all)

#    User.create!(:login => "foo", :email => "foo@grantvote.com",
#                   :password => "pass", :password_confirmation => "pass")
#      Profile.create!(:user_id => 1, :login => "foo")
#    
#    User.create!(:login => "bar", :email => "bar@grantvote.com",
#                   :password => "pass", :password_confirmation => "pass")
#      Profile.create!(:user_id => 2, :login => "bar")
#    
#    User.create!(:login => "baz", :email => "baz@grantvote.com",
#                   :password => "pass", :password_confirmation => "pass")
#      Profile.create!(:user_id => 3, :login => "baz") 
    
    Group.populate 5 do |g|
      g.name = Populator.words(2..5).titleize
      g.purpose = Populator.words(5..10).titleize
      g.dues = [2, 5, 9, 12]
      g.funds = 100..500
      g.wait = 7
      g.created_at = 2.months.ago..Time.now
#      g.photo_file_size = 1
#      g.photo_content_type = 'image/png'
#      g.photo_file_name = 'not set'
      Membership.populate 1 do |m|
        m.user_id = 1
        m.group_id = g.id
        m.interest = true
      end      
      Membership.populate 1 do |m|
        m.user_id = 2
        m.group_id = g.id
        m.interest = true
      end      
      Membership.populate 1 do |m|
        m.user_id = 3
        m.group_id = g.id
        m.interest = true
      end
    end
    
    # set permalinks
    Group.find(:all).each(&:save!)
        
    Grant.populate 30 do |g|
      g.user_id = [1, 2, 3]
      g.group_id = 1..5
      g.name = Faker::Name.name
      g.proposal = Populator.sentences(2..10)
      g.amount = 20..50
      g.awarded = [true, false]
      g.final = [true, false]
#      g.photo_file_size = 1
#      g.photo_content_type = 'image/png'
#      g.photo_file_name = 'not set'
      g.created_at = 1.month.ago..Time.now     
    end

    # set permalinks
    Grant.find(:all).each(&:save!)
    
  end
end


