namespace :db do
  desc "Erase and fill blitz general fund"
  task :blitz_funds => :environment do

    [BlitzFund].each(&:delete_all)

    BlitzFund.create!(:dues => 5, :general_pool => 1000)
    
  end
end
