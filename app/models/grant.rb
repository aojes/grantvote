class Grant < ActiveRecord::Base
  
  AWARD_THRESHOLD_PCT = 50
  
  MIN_AWARD = 10
  MIN_NAME, MAX_NAME = [2, 60]
  
  GREEN, BLUE, RED, SCALE = ["E6EFC2", "DFF4FF", "FBE3E4", "DFDFDF"]
  
  SESSION_BAR_CHART_X, SESSION_BAR_CHART_Y  = [191, 42]
  AWARD_CHART_X, AWARD_CHART_Y = [92, 50]
  
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
                             },                                    
   :url  => "/assets/grants/:id/:style/:basename.:extension",
   :path => ":rails_root/public/assets/grants/:id/:style/:basename.:extension"
   
  validates_attachment_size :photo, :less_than => Group::MAX_FILE_SIZE
  validates_attachment_content_type :photo, 
                              :content_type => ['image/jpeg', 'image/png']
 
  validates_presence_of :name, :proposal, :amount
  validates_length_of :name, :in => MIN_NAME..MAX_NAME,
              :message => "length can be #{MIN_NAME} to #{MAX_NAME} characters"
  validates_numericality_of :amount, :only_integer => true, 
    :greater_than_or_equal_to => MIN_AWARD, 
    :message => "can be an integer value greater than or equal to $#{MIN_AWARD}"
  validates_attachment_presence :photo
   
end



