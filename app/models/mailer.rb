class Mailer < ActionMailer::Base
  def invitation(invitation, signup_url)
    subject    'Invitation'
    recipients invitation.email
    from       'foo@egrantvote.com'
    body       :invitation => invitation, :signup_url => root_path
    invitation.update_attribute(:sent_at, Time.now)
  end
end
