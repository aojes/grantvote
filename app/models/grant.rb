class Grant < ActiveRecord::Base
  
  AWARD_THRESHOLD, AWARD_THRESHOLD_PCT = [0.500, 50]
  
  MIN_AWARD = 10
  MIN_NAME, MAX_NAME = [2, 60]
  
  GREEN, BLUE, RED, SCALE = ["E6EFC2", "DFF4FF", "FBE3E4", "DFDFDF"]
  
  SESSION_BAR_CHART_X, SESSION_BAR_CHART_Y  = [191, 42]
  AWARD_CHART_X, AWARD_CHART_Y = [92, 50]
  
  belongs_to :group
  belongs_to :user
  has_many :votes
  has_many :comments, :as => :commentable

  has_permalink :name
  
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
  ## defer
  # validates_attachment_presence :photo
  
  named_scope :awarded,  :conditions => {:awarded => true}
  named_scope :defeated, :conditions => {:final => true, :awarded => false}
  named_scope :session,  :conditions => {:final => false}
  named_scope :user_group_session, lambda { |*args|
    {  :conditions => 
          { :user_id => args.first, :group_id => args.second, :final => false } 
    }
  }
  named_scope :chronological, :order => "created_at ASC"

  def voters
    group.memberships.voters.count
  end

  def vote_threshold
    (voters * AWARD_THRESHOLD).ceil
  end

  def finalizable?
    passes? || denies?
  end

  def passes?
    votes.yea.count > vote_threshold || voters == 1
  end

  def denies?
    votes.nay.count > vote_threshold
  end

  def award!
    transaction do
      update_attributes!(:final => true, :awarded => true)
      group.update_attributes!(:funds => (group.funds - amount))
      # ...or better yet:
      # group.deduct_funds!(amount)
    end
  end

  def deny!
    update_attributes!(:final => true, :awarded => false)
  end   
  
  def to_param
    permalink
  end
  
end



