class Profile < ActiveRecord::Base
  belongs_to :user
  has_permalink :login, :update => true
  
  def to_param
    permalink
  end
  
end
