class Group < ActiveRecord::Base
  
  AWARD_THRESHOLD = 0.500 # 50% OF CURRENT AND FUTURE VOTING MEMBERS
  
  has_many :grants
  has_many :memberships, :dependent => :destroy # don't destroy groups
  has_many :users, :through => :memberships
  has_many :comments, :as => :commentable  
  
  validates_presence_of :name, :purpose, :dues
  validates_numericality_of :dues, :minimum => 2, :only_integer => true,
                      :message => "can be an integer value of minimum 2"
  
  validates_length_of :name, :in => 2..50, 
                      :message => "can be 3 to 50 characters"
  
  validates_length_of :purpose, :in => 3..255,
                      :message => "can be 3 to 255 characters"
  
  has_attached_file :photo, :styles => {
                               :thumb  => "32x32#", 
                               :small  => "48x48#",
                               :medium => "75x75#", 
                               :large  => "256x256>" 
                             }
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, 
                                    :content_type => ['image/jpeg', 'image/png']
  
  named_scope :interest, lambda { |*args|
    { :conditions => { :dues => args.first..args.second } }
  }                                  
end
