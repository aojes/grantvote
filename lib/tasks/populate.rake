namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [Group].each(&:delete_all)
    
    Group.populate 5 do |g|
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
  end
end


