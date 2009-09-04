namespace :db do
  desc "Create new blitz fund"
  task :populate_funds => :environment do

    [BlitzFund].each(&:delete_all)

    BlitzFund.populate 1 do |b|
      b.dues = Payment::AMOUNT
      b.general_pool = 100
    end
  end
end

