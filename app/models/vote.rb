class Vote < ActiveRecord::Base

  belongs_to :user
  belongs_to :group
  belongs_to :grant
  belongs_to :blitz

  validates_presence_of   :user_id, :group_id, :grant_id, :blitz_id, :cast
  validates_inclusion_of  :cast, :in => %w(yea nay)
  validates_uniqueness_of :user_id, :scope => [:grant_id, :blitz_id]

  named_scope :yea, :conditions => { :cast => "yea" }
  named_scope :nay, :conditions => { :cast => "nay" }

  before_create :check_session_limit
  after_create :check_grant_finalization

  def check_session_limit
    if grant and grant.votes.count.zero? and user == grant.user
      allow_grant? and grant.update_attributes!(:session => true)
    elsif blitz and blitz.votes.count.zero? and user == blitz.user
      allow_blitz? and blitz.update_attributes!(:session => true)
    else
      true
    end
  end

  def allow_grant?
    group.grants.user_group_session(user.id, group.id).
      detect { |g| !g.votes.count.zero? }.nil?
  end

  def allow_blitz?
    user.blitz_interest and user.blitzes.session.count.zero? and solvent_fund?
  end

  def check_grant_finalization
    if grant and grant.finalizable?
      if grant.passes?
        grant.award!
      else
        grant.deny!
      end
    elsif blitz
      if blitz.finalizable?
        if blitz.passes?
          blitz.award!
        else
          blitz.deny!
        end
      end
    end
  end

  def final_message
    grant.final ? grant.awarded ? 'Grant awarded!' : 'Grant denied.' : nil
  end

  def limit_message
    !group.grants.user_group_session(user.id, group.id).count.zero? ?
                'You may have only one grant in session per group.' : nil
  end

  def solvent_fund?
    Blitz.find_all_by_session(true).collect! {|b| b.amount }.
      sum + blitz.amount <= blitz.blitz_fund.general_pool
  end
end

