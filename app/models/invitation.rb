class Invitation < ActiveRecord::Base
 # belongs_to :sender, :class_name => 'User'
 # has_one :recipient, :class_name => 'User'

  validates_format_of :email,
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :on => :create
  validates_uniqueness_of :email
  validate :recipient_is_not_registered
  validate :sender_has_invitations, :if => :sender

  before_create :generate_token
  before_create :decrement_sender_count, :if => :sender

  after_create :send_invitation_notice

  def send_invitation_notice
  @invitations = Invitation.find(:all)

    @invitations.each do | i |
      Mailer.deliver_invitation_request_notice(i) if i.sender_id.nil?
    end
  end

private

  def recipient_is_not_registered
    errors.add :email, 'is already registered' if User.find_by_email(email)
  end

  def sender_has_invitations
    unless sender.invitation_limit > 0
      errors.add_to_base 'You have reached your limit of invitations to send.'
    end
  end

  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end

  def decrement_sender_count
    sender.decrement! :invitation_limit
  end

end

