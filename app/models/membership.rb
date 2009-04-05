class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  def principality!
    self.user.principal = true
  end

end
