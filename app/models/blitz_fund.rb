class BlitzFund < ActiveRecord::Base
  has_many :blitzes
  
  def deduct_funds!(amount)
    update_attributes!(:general_pool => (general_pool - amount))
  end
end
