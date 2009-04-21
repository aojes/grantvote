class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :grant
  has_many :comments, :as => :commentable 
  
  validates_presence_of   :user_id, :group_id, :grant_id, :cast
  validates_inclusion_of  :cast, :in => %w(yea nay)
  validates_uniqueness_of :user_id, :scope  => :grant_id

  named_scope :yea, :conditions => { :cast => "yea" }
  named_scope :nay, :conditions => { :cast => "nay" }  
  
  def finalized_grant?
    voters    = self.group.memberships.voters.count
    threshold = (voters * Group::AWARD_THRESHOLD).ceil 
  
    votes_yea = self.grant.votes.yea.count
    votes_nay = self.grant.votes.nay.count   
  
    if votes_yea > threshold or voters == 1
      self.grant.final   = true
      self.grant.awarded = true
      self.group.funds  -= self.grant.amount
      self.group.save             #
      self.grant.save             # or raise error? TODO
    elsif votes_nay > threshold
      self.grant.final = true
      self.grant.awarded = false
      self.grant.save             #
    else
      false
    end
  end
  
  def final_message
    self.grant.awarded ? "Grant awarded!" : "Grant defeated."
  end
  
end
