namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'


    [Group, Membership, Grant, Blitz, Vote, Communication].each(&:delete_all)

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

      Grant.populate 6 do |grant|
        grant.user_id = 4
        grant.group_id = group.id
        grant.name = Faker::Name.name
        grant.proposal = Populator.sentences(2..12)
        grant.media = ''
        grant.amount = 20..50
        grant.session = false
        grant.awarded = true
        grant.final = true
        grant.created_at = 1.year.ago..Time.now - 1.month

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
          v.user_id = 3
          v.grant_id = grant.id
          v.group_id = group.id
          v.blitz_id = 0
          v.cast = "yea"
          v.created_at = 1.month.ago..Time.now
          v.updated_at = v.created_at
        end
      end

      Grant.populate 6 do |grant|
        grant.user_id = 3
        grant.group_id = group.id
        grant.name = Faker::Name.name
        grant.proposal = Populator.sentences(2..12)
        grant.media = ''
        grant.amount = 20..50
        grant.session = true
        grant.awarded = false
        grant.final = false
        grant.created_at = 1.year.ago..Time.now - 1.month

        Vote.populate 1 do |v|
          v.user_id = 3
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
      end
    end

    # set permalinks
    Group.find(:all).each(&:save!)
    Grant.find(:all).each(&:save!)


    Blitz.populate 42 do |b|
      b.user_id = 5
      b.blitz_fund_id = 3
      b.name = Faker::Name.name
      b.proposal = Populator.sentences(4..9)
      b.media = ''
      b.amount = 45..97
      b.votes_win = 1 + User.count(:conditions => {:blitz_interest => true}) / Payment::DIVIDEND
      b.session = true
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

    Blitz.populate 12 do |b|
      b.user_id = 3
      b.blitz_fund_id = 3
      b.name = Faker::Name.name
      b.proposal = Populator.sentences(4..9)
      b.media = ''
      b.amount = 45..55
      b.votes_win = User.count(:conditions => {:blitz_interest => true}) / Blitz::DIVISOR
      b.session = true
      b.awarded = false
      b.final = false
      Vote.populate 1 do |v|
        v.user_id = b.user_id
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

    Communication.populate 50 do |c|
      c.user_id = [1, 2, 3, 4, 5]
      c.content = Populator.sentences 1
      c.created_at = 1.month.ago..Time.now
    end
  end
end

