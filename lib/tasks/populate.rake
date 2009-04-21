namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [Group, Membership, Grant, Vote].each(&:delete_all)
    
    Group.populate 5 do |g|
      g.name = Populator.words(2..5).titleize
      g.purpose = Populator.words(5..10).titleize
      g.dues = [2, 5, 9, 12]
      g.funds = 100..500
      g.wait = 7
      g.created_at = 2.months.ago..Time.now
      
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
    
    
    Grant.populate 50 do |g|
      g.user_id = [1, 2]
      g.group_id = 1..3
      g.name = Faker::Name.name
      g.proposal = Populator.sentences(2..10)
      g.amount = 20..50
      g.final = [true, false]
      g.awarded = [true, false]
      g.created_at = 1.month.ago..Time.now     
    end
    
  end
end


