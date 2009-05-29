namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    
    [Group, Membership, Grant, Vote].each(&:delete_all)

    Group.populate 20 do |g|
      g.name = Populator.words(2..5).titleize
      g.purpose = Populator.words(5..10).titleize
      g.dues = 5
      g.funds = 100..500
      g.created_at = 2.months.ago..Time.now

      Membership.populate 1 do |m|
        m.user_id = 1
        m.group_id = g.id
        m.interest = true
        m.role = "creator"
        m.public = true
        m.contributes = 20
        m.rewards = 10
      end      
      Membership.populate 1 do |m|
        m.user_id = 2
        m.group_id = g.id
        m.interest = true
        m.role = "moderator"
        m.public = true
        m.contributes = 20
        m.rewards = 10
      end      
      Membership.populate 1 do |m|
        m.user_id = 3
        m.group_id = g.id
        m.interest = true
        m.role = "basic"
        m.public = true
        m.contributes = 20
        m.rewards = 10
      end      
      Membership.populate 1 do |m|
        m.user_id = 4
        m.group_id = g.id
        m.interest = true
        m.role = "basic"
        m.public = true
        m.contributes = 20
        m.rewards = 10
      end      
      Membership.populate 1 do |m|
        m.user_id = 5
        m.group_id = g.id
        m.interest = true
        m.role = "basic"
        m.public = true
        m.contributes = 20
        m.rewards = 10
      end
    end
    
    # set permalinks
    Group.find(:all).each(&:save!)
        
    Grant.populate 50 do |g|
      g.user_id = [1, 2, 3, 4, 5]
      g.group_id = 1..5
      g.name = Faker::Name.name
      g.proposal = Populator.sentences(2..10)
      g.media = ""
      g.amount = 20..50
      g.awarded = [true, false, false]
      g.final = [true, true, false]

      g.created_at = 1.year.ago..Time.now
      g.updated_at = 1.week.ago..Time.now
      Vote.populate 1 do |v|
        v.user_id = [3, 4, 5]
        v.grant_id = g.id
        v.group_id = 1..5
        v.cast = ["yea", "nay"]
        v.created_at = 1.month.ago..Time.now
        v.updated_at = v.created_at
      end     
    end

    # set permalinks
    Grant.find(:all).each(&:save!)
    
  end
end
