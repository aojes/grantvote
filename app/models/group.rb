class Group < ActiveRecord::Base
  
  AWARD_THRESHOLD, AWARD_THRESHOLD_PCT = [0.500, 50]
  
  MIN_NAME, MAX_NAME = [2, 140]
  MIN_PURPOSE, MAX_PURPOSE = [3, 200]
  MIN_DUES, MAX_DUES = [2, 100]
  MAX_FILE_SIZE = 5.megabytes
  
  # acts_as_taggable_on :tags
  
  has_many :grants                            #   
  has_many :memberships                       # don't destroy any data
  has_many :users, :through => :memberships
  has_many :comments, :as => :commentable  

  has_permalink :name
  
  validates_presence_of :name, :purpose, :dues
  validates_length_of :name, :in => MIN_NAME..MAX_NAME, 
                   :message => "can be #{MIN_NAME} to #{MAX_NAME} characters"
  validates_uniqueness_of :name
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
                             },                                    
   :url  => "/assets/groups/:id/:style/:basename.:extension",
   :path => ":rails_root/public/assets/groups/:id/:style/:basename.:extension"
   
  validates_attachment_size :photo, :less_than => MAX_FILE_SIZE
  validates_attachment_content_type :photo, 
                      :content_type => ['image/jpeg', 'image/png', 'image/gif']
  ## defer
  # validates_attachment_presence :photo
  
  named_scope :interest, lambda { |*args|
    { :conditions => { :dues => args.first..args.second } }
  }
  
  def to_param
    permalink
  end
  
                                
end
