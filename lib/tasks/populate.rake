namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [Group, Grant].each(&:delete_all)
    
    Group.populate 3 do |g|
      g.name = Populator.words(2..5).titleize
      g.purpose = Populator.words(5..10).titleize
      g.dues = [1, 2, 5, 9, 15]
      g.dues_collected = 99..499
      g.grants_written = 20..50
      g.votes_held = 5..10
      g.yield_average = 20..50
      g.wait = 7..45
      g.withdrawals = 10..40
      g.created_at = 2.years.ago..Time.now
    end
    
    Grant.populate 20 do |g|
      g.user_id = [1, 2]
      g.group_id = 1..3
      g.name = Faker::Company.name
      g.proposal = Populator.sentences(2..10)
      g.amount = 20..50
      g.final = [true, false]
      g.awarded = [true, false]
      g.created_at = 1.month.ago..2.days.ago      
    end

  end
end


