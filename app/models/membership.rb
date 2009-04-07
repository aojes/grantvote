class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  validates_uniqueness_of :user_id, :scope => :group_id
  
  def principality!
    self.user.principal = true
  end

end
