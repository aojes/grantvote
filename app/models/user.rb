class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :comments, :as => :commentable

  has_attached_file :photo, :styles => { 
                               :small  => "75x75>", 
                               :medium => "150x150>",
                               :large  => "256x256>" 
                             }
  validates_attachment_size :photo, :less_than => 3.megabytes
  validates_attachment_content_type :photo, 
                                    :content_type => ['image/jpeg', 'image/png']  
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

end
