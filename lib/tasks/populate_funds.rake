namespace :db do
  desc "Erase and fill users table"
  task :populate_funds => :environment do

    [BlitzFund].each(&:delete_all)


    BlitzFund.populate 1 do |b|
      b.dues = 10
      b.general_pool = 1000
    end
    BlitzFund.populate 1 do |b|
      b.dues = 4.85
      b.general_pool = 1000
    end
    BlitzFund.populate 1 do |b|
      b.dues = 3
      b.general_pool = 1000
    end
  end
end

