namespace :db do
  desc "Erase and fill users table"
  task :populate_funds => :environment do

    [BlitzFund].each(&:delete_all)

    BlitzFund.populate 1 do |b|
      b.dues = 4.85
      b.general_pool = 0
      b.awards = 0
    end
  end
end

