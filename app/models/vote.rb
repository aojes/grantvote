class Vote < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :group
  belongs_to :grant
  has_many :comments, :as => :commentable 
  
  validates_presence_of   :user_id, :group_id, :grant_id, :cast
  validates_inclusion_of  :cast, :in => %w(yea nay)
  validates_uniqueness_of :user_id, :scope => :grant_id

  named_scope :yea, :conditions => { :cast => "yea" }
  named_scope :nay, :conditions => { :cast => "nay" }  
  
  before_create :check_session_limit
  after_create :check_grant_finalization
  
  def check_session_limit
    if user == grant.user
      existing_user_group_session ? nil : true
    else
      true
    end       
  end
  
  def existing_user_group_session
    not group.grants.user_group_session(user.id, group.id).empty?
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
    grant.final ? grant.awarded ? "Grant awarded!" : "Grant defeated." : nil
  end
  
  def session_limit_message
    existing_user_group_session ? 
      "You may have only one grant in session per group." : nil
  end  
end
