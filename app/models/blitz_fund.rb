class BlitzFund < ActiveRecord::Base
  has_many :blitzes

  def cycle!(amount)
    update_attributes!(:general_pool => (general_pool - amount),
                       :awards       => (awards       + amount))
  end

end

