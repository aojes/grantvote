class Group < ActiveRecord::Base

  AWARD_THRESHOLD, AWARD_THRESHOLD_PCT = [0.500, 50]

  MIN_NAME, MAX_NAME = [2, 140]
  MIN_PURPOSE, MAX_PURPOSE = [3, 200]

  MAX_FILE_SIZE = 5.megabytes

  # acts_as_taggable_on :tags  FIXME defer

  has_many :grants                            #
  has_many :memberships                       # don't destroy any data
  has_many :users, :through => :memberships
  has_many :comments, :as => :commentable

  define_index do
    indexes purpose
    indexes :name, :sortable => true
    indexes comments.content, :as => :comment_content
  end

  has_permalink :name, :update => true

  validates_presence_of :name, :purpose # :dues
  validates_length_of :name, :in => MIN_NAME..MAX_NAME,
                   :message => "can be #{MIN_NAME} to #{MAX_NAME} characters"
  validates_uniqueness_of :name
  validates_length_of :purpose, :in => MIN_PURPOSE..MAX_PURPOSE,
             :message => "can be #{MIN_PURPOSE} to #{MAX_PURPOSE} characters"
  # For now, dues are preset at $5
  # validates_inclusion_of :dues, :in => DUES
#  validates_numericality_of :dues, :only_integer => true,
#    :greater_than_or_equal_to => MIN_DUES, :less_than_or_equal_to => MAX_DUES,
#         :message => "can be an integer value of #{MIN_DUES} up to #{MAX_DUES}"
  has_attached_file :photo, #:default_url => "/images/defaults/group_small.png",
    :styles => {
        :thumb   => "32x32#",
        :small   => "48x48#",
        :medium  => "75x75#",
        :large   => "92x92#",
        :display => "256x256>"
      },
    :url  => "/assets/groups/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/groups/:id/:style/:basename.:extension"

  validates_attachment_size :photo, :less_than => MAX_FILE_SIZE
  validates_attachment_content_type :photo,
                      :content_type => ['image/jpeg', 'image/png', 'image/gif']
  ## defer
  # validates_attachment_presence :photo SET EDIT BEFORE PUBLIC

  named_scope :name_or_purpose_like, lambda { |*args|
    {
      :conditions => ["name LIKE ? OR purpose LIKE ?", "#{args[0]}%", "#{args[0]}%"]
    }
  }

  def voters_count
    memberships.voters.count
  end

  def solvent?(grant)
    if grant.votes.count.zero?
      funds >= grant.group.grants.session.sum(:amount) + grant.amount
    else
      funds >= grant.group.grants.session.sum(:amount)
    end
  end

  def deduct_funds!(amount)
    update_attributes!(:funds => (funds - amount))
  end

  def authorize_edit?(user)
    creator = Membership.exists?(:role => 'creator', :user_id => user.id,
          :group_id => self.id)
    moderator = Membership.exists?(:role => 'moderator', :user_id => user.id,
          :group_id => self.id)
    (creator and funds.zero?) or (moderator and funds.zero?)
  end

  def to_param
    permalink
  end

end

