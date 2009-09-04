namespace :db do
  desc "Create new blitz fund"
  task :populate_funds => :environment do

    BlitzFund.create!(:dues => Payment::AMOUNT, :general_pool => 20, :awards => 0)
  end
end

