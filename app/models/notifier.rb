class Notifier < ActionMailer::Base

  default_url_options[:host] = "www.grantvote.com"

  def test_email(recipient_address)
    recipients    recipient_address
    from          "Grantvote <support@grantvote.com>"
    subject       "test"
    sent_on       Time.now
    body          :url => "http://www.grantvote.com"
    content_type  "text/html"
  end

  def welcome_email(user)
    recipients    user.email
    from          "Grantvote <support@grantvote.com>"
    subject       "Welcome!"
    sent_on       Time.now
    body          :user => user, :url => "http://www.grantvote.com/login"
  end

  def event_notice(notification)
    recipients    notification.user.email
    from          "Grantvote <support@grantvote.com>"
    subject       "Notification"
    sent_on       Time.now
    body          :notice => notification
    content_type  "text/html"
  end

  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          "Grantvote <support@grantvote.com>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
end

