namespace :db do
  desc "Create new blitz fund"
  task :populate_new_fund => :environment do

    BlitzFund.populate 1 do |b|
      b.dues = Payment::AMOUNT
      b.general_pool = 100
      b.awards = 100
    end
  end
end

