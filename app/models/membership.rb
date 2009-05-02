class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  validates_uniqueness_of :user_id, :scope => :group_id
  
  named_scope :voters,  :conditions => { :interest => true } 
  named_scope :members, :conditions => { :interest => false } 
  
end
