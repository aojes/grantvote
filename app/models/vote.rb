class Vote < ActiveRecord::Base
    
  belongs_to :user
  belongs_to :group
  belongs_to :grant
  
  validates_presence_of   :user_id, :group_id, :grant_id, :cast
  validates_inclusion_of  :cast, :in => %w(yea nay)
  validates_uniqueness_of :user_id, :scope => :grant_id

  named_scope :yea, :conditions => { :cast => "yea" }
  named_scope :nay, :conditions => { :cast => "nay" }  
  
  before_create :check_session_limit
  after_create :check_grant_finalization
  
  def check_session_limit
    if user == grant.user
      allow_session?
    else
      true
    end       
  end
  
  def allow_session?
    group.grants.user_group_session(user.id, group.id).
      detect { |g| !g.votes.count.zero? }.nil?
  end  
  
  def check_grant_finalization
    if grant.finalizable?
      if grant.passes?
        grant.award!
      else
        grant.deny!
      end
    end
  end  
  
  def final_message
    grant.final ? grant.awarded ? "Grant awarded!" : "Grant denied." : nil
  end
  
  def limit_message
    !group.grants.user_group_session(user.id, group.id).
      detect { |g| !g.votes.count.zero? }.nil? ?
        "You may have only one grant in session per group." : nil
  end  
end
