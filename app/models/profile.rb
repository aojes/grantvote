class Profile < ActiveRecord::Base
  belongs_to :user
  has_permalink :login
  
  def to_param
    permalink
  end
  
end
