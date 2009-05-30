class Mailer < ActionMailer::Base
  default_url_options[:host] = "67.23.26.17"
  def invitation(invitation)
    subject    'Invitation'
    recipients invitation.email
    from       'foo@egrantvote.com'
    body       :invitation => invitation, :signup_url => "http://67.23.26.17/signup"
    content_type "text/html"
    invitation.update_attribute(:sent_at, Time.now)
  end
end
