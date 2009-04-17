class Grant < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  has_many :votes
  has_many :comments, :as => :commentable
  
  has_attached_file :photo, :styles => {
                               :thumb  => "32x32#", 
                               :small  => "48x48#",
                               :med_sm => "75x75#",
                               :medium => "92x92#", 
                               :large  => "256x256>" 
                             }
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, 
                                    :content_type => ['image/jpeg', 'image/png']                                    
  
  validates_presence_of :name, :proposal, :amount
  # TODO round amount to nearest integer
  validates_numericality_of :amount, :only_integer => true, :minimum => 10,
            :message => "can be an integer value of 10 or more"
    
end
