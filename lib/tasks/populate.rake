namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    
    [Group, Membership, Grant, Blitz, Vote].each(&:delete_all)

    Group.populate 1 do |g|
      g.name = Populator.words(3..5).titleize
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
        
    Grant.populate 1 do |g|
      g.user_id = 5
      g.group_id = 1
      g.name = Faker::Name.name
      g.proposal = Populator.sentences(2..12)
      g.media = ""
      g.amount = 20..50
      g.awarded = false
      g.final = false

      g.created_at = 1.year.ago..Time.now
      g.updated_at = 1.week.ago..Time.now
      Vote.populate 1 do |v|
        v.user_id = g.user_id
        v.grant_id = g.id
        v.group_id = 1
        v.blitz_id = 0
        v.cast = "yea"
        v.created_at = 1.month.ago..Time.now
        v.updated_at = v.created_at
      end
      Vote.populate 1 do |v|
        v.user_id = 4
        v.grant_id = g.id
        v.group_id = 1
        v.blitz_id = 0
        v.cast = "yea"
        v.created_at = 1.month.ago..Time.now
        v.updated_at = v.created_at
      end     
    end

    # set permalinks
    Grant.find(:all).each(&:save!)
    
    Blitz.populate 1 do |b|
      b.user_id = 5
      b.blitz_fund_id = 1
      b.name = Faker::Name.name
      b.proposal = Populator.sentences(4..9)
      b.media = ""
      b.amount = 10..47
      b.votes_win = 1 + b.amount / 5
      b.awarded = false
      b.final = false

      b.created_at = 1.year.ago..Time.now
      b.updated_at = 1.week.ago..Time.now
      Vote.populate 1 do |v|
        v.user_id = 5
        v.blitz_id = b.id
        v.grant_id = 0
        v.group_id = 0
        v.cast = 'yea'
        v.created_at = 1.day.ago..Time.now
        v.updated_at = v.created_at
      end   
    end

    # set permalinks
    Blitz.find(:all).each(&:save!)    
  end
end
