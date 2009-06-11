class Mailer < ActionMailer::Base
   default_url_options[:host] = "www.grantvote.com"
   def invitation(invitation, signup_url, user)
    subject      'Invitation'
    recipients   invitation.email
    from         'noreply@grantvote.com'
    body         :invitation => invitation, :signup_url => signup_url, :user => user
    content_type "text/html"
    invitation.update_attribute(:sent_at, Time.now)
   end

   def invitation_request_notice(invitation)
    subject    'New Request for Private Beta'
    recipients 'tefflox@gmail.com, bridgeutopia@gmail.com'
    from       'noreply@grantvote.com'
    body       :invitation => invitation
    content_type "text/html"
   end

end

