class User < ActiveRecord::Base
  acts_as_authentic
 # acts_as_tagger
  
  has_one  :profile
  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :votes
  has_many :grants
  has_many :comments, :as => :commentable

  has_attached_file :photo, :styles => {
                               :thumb  => "32x32#", 
                               :small  => "48x48#",
                               :medium => "75x75#", 
                               :large  => "256x256>" 
                             },                                    
   :url  => "/assets/users/:id/:style/:basename.:extension",
   :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension"
   
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, 
                                    :content_type => ['image/jpeg', 'image/png']  
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

end
