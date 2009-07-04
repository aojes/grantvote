namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    
    [Group, Membership, Grant, Blitz, Vote].each(&:delete_all)

    Group.populate 12 do |group|
      group.name = Populator.words(3..5).titleize
      group.purpose = Populator.words(5..10).titleize
      group.dues = 5
      group.funds = 100..500
      group.created_at = 2.months.ago..Time.now

      Membership.populate 1 do |m|
        m.user_id = 1
        m.group_id = group.id
        m.interest = true
        m.role = "creator"
        m.public = true
        m.contributes = 20
        m.rewards = 10
      end      
      Membership.populate 1 do |m|
        m.user_id = 2
        m.group_id = group.id
        m.interest = true
        m.role = "moderator"
        m.public = true
        m.contributes = 20
        m.rewards = 10
      end      
      Membership.populate 1 do |m|
        m.user_id = 3
        m.group_id = group.id
        m.interest = true
        m.role = "basic"
        m.public = true
        m.contributes = 20
        m.rewards = 10
      end      
      Membership.populate 1 do |m|
        m.user_id = 4
        m.group_id = group.id
        m.interest = true
        m.role = "basic"
        m.public = true
        m.contributes = 20
        m.rewards = 10
      end      
      Membership.populate 1 do |m|
        m.user_id = 5
        m.group_id = group.id
        m.interest = true
        m.role = "basic"
        m.public = true
        m.contributes = 20
        m.rewards = 10
      end

      Grant.populate 12 do |grant|
        grant.user_id = 5
        grant.group_id = group.id
        grant.name = Faker::Name.name
        grant.proposal = Populator.sentences(2..12)
        grant.media = ['', '', %(<object width="425" height="344"><param name="movie" value="http://www.youtube.com/v/9QtR0D-VK-M&hl=en&fs=1&"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/9QtR0D-VK-M&hl=en&fs=1&" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="425" height="344"></embed></object>)]
        grant.amount = 20..50
        grant.awarded = [false, true]
        grant.final = [false, true]
        grant.created_at = 1.year.ago..Time.now
        grant.updated_at = 1.week.ago..Time.now

        Vote.populate 1 do |v|
          v.user_id = grant.user_id
          v.grant_id = grant.id
          v.group_id = group.id
          v.blitz_id = 0
          v.cast = "yea"
          v.created_at = 1.month.ago..Time.now
          v.updated_at = v.created_at
        end
        Vote.populate 1 do |v|
          v.user_id = 4
          v.grant_id = grant.id
          v.group_id = group.id
          v.blitz_id = 0
          v.cast = "yea"
          v.created_at = 1.month.ago..Time.now
          v.updated_at = v.created_at
        end
        Vote.populate 1 do |v|
          v.user_id = 3
          v.grant_id = grant.id
          v.group_id = group.id
          v.blitz_id = 0
          v.cast = "yea"
          v.created_at = 1.month.ago..Time.now
          v.updated_at = v.created_at
        end     
      end
    end
    
    # set permalinks
    Group.find(:all).each(&:save!)
    Grant.find(:all).each(&:save!)
    
    Blitz.populate 24 do |b|
      b.user_id = 5
      b.blitz_fund_id = 1
      b.name = Faker::Name.name
      b.proposal = Populator.sentences(4..9)
      b.media = ['', '', %(<object width="425" height="344"><param name="movie" value="http://www.youtube.com/v/9QtR0D-VK-M&hl=en&fs=1&"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/9QtR0D-VK-M&hl=en&fs=1&" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="425" height="344"></embed></object>)]
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
      Vote.populate 1 do |v|
        v.user_id = 4
        v.blitz_id = b.id
        v.grant_id = 0
        v.group_id = 0
        v.cast = 'nay'
        v.created_at = 1.day.ago..Time.now
        v.updated_at = v.created_at
      end   
    end

    # set permalinks
    Blitz.find(:all).each(&:save!)    
  end
end
