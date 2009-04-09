class Group < ActiveRecord::Base

  has_many :grants
  has_many :votes
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
  has_many :comments, :as => :commentable  
  
  validates_presence_of :name, :purpose

  has_attached_file :photo, :styles => {
                               :thumb  => "32x32#", 
                               :small  => "48x48#",
                               :medium => "75x75#", 
                               :large  => "256x256>" 
                             }
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, 
                                    :content_type => ['image/jpeg', 'image/png']    
  
end
