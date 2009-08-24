class User < ActiveRecord::Base
  acts_as_authentic
  # acts_as_tagger defer_FIXME

  has_one  :profile
  has_one  :credit
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship",
                                 :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :grants
  has_many :blitzes
  has_many :votes
  has_many :comments, :as => :commentable
  has_many :communications
  has_many :payments
  has_many :payment_notifications
  has_many :sent_invitations,
             :class_name => 'Invitation', :foreign_key => 'sender_id'
  belongs_to :invitation

  accepts_nested_attributes_for :profile

  has_attached_file :photo, #:default_url => "/images/defaults/user_medium.png",
    :styles => {
        :thumb   => "32x32#",
        :small   => "48x48#",
        :medium  => "75x75#",
        :large   => "92x92#",
        :display => "256x256>"
      },
   :url  => "/assets/users/:id/:style/:basename.:extension",
   :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension"

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo,
                       :content_type => ['image/jpeg', 'image/gif', 'image/png']

  validates_presence_of :invitation_id, :message => 'is required'
  validates_uniqueness_of :invitation_id

  MIN_NAME, MAX_NAME = [2, 26]

  validates_length_of :login, :in => MIN_NAME..MAX_NAME

  attr_accessor_with_default :password_confirm_vital, ''
  attr_accessor_with_default :new_password, ''
  attr_accessor_with_default :confirm_new_password, ''
  attr_accessor_with_default :current_password, ''

  before_create :set_invitation_limit

  def cycle_interest!(amount)
    update_attributes!(:blitz_rewards => (blitz_rewards + amount))
    if blitz_contributes <= blitz_rewards
      update_attributes!(:blitz_interest => false)
    end
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end

  private

  def set_invitation_limit
    self.invitation_limit = 5
  end


end

