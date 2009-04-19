class Group < ActiveRecord::Base
  
  AWARD_THRESHOLD = 0.500
  
  MIN_NAME, MAX_NAME = [2, 50]
  MIN_PURPOSE, MAX_PURPOSE = [3, 200]
  MIN_DUES, MAX_DUES = [2, 100]
  MAX_FILE_SIZE = 5.megabytes
  
  has_many :grants
  has_many :memberships, :dependent => :destroy # don't destroy groups
  has_many :users, :through => :memberships
  has_many :comments, :as => :commentable  
  
  validates_presence_of :name, :purpose, :dues
  validates_length_of :name, :in => MIN_NAME..MAX_NAME, 
                   :message => "can be #{MIN_NAME} to #{MAX_NAME} characters"
  validates_length_of :purpose, :in => MIN_PURPOSE..MAX_PURPOSE,
             :message => "can be #{MIN_PURPOSE} to #{MAX_PURPOSE} characters"  
  validates_numericality_of :dues, :only_integer => true, 
    :greater_than_or_equal_to => MIN_DUES, :less_than_or_equal_to => MAX_DUES, 
         :message => "can be an integer value of #{MIN_DUES} up to #{MAX_DUES}"
  has_attached_file :photo, :styles => {
                               :thumb  => "32x32#", 
                               :small  => "48x48#",
                               :medium => "75x75#", 
                               :large  => "256x256>" 
                             }
  validates_attachment_size :photo, :less_than => MAX_FILE_SIZE
  validates_attachment_content_type :photo, 
                      :content_type => ['image/jpeg', 'image/png', 'image/gif']
  validates_attachment_presence :photo
  
  named_scope :interest, lambda { |*args|
    { :conditions => { :dues => args.first..args.second } }
  }                                  
end
