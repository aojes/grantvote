class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  validates_uniqueness_of :user_id, :scope => :group_id
  
  named_scope :voters,  :conditions => { :interest => true } 
  named_scope :members, :conditions => { :interest => false } 
  
  def cycle_membership!(amount)
    new_rewards  = rewards + amount
    new_interest = contributes - new_rewards > 0 ? true : false
    update_attributes!(:rewards => new_rewards, :interest => new_interest)
  end
    
end
