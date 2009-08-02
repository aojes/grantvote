class Notifier < ActionMailer::Base
  
  default_url_options[:host] = "localhost"
  
  def welcome_email(user)  
    recipients    user.email 
    from          "Jesse <tefflox@gmail.com>"  
    subject       "Welcome"  
    sent_on       Time.now 
    body          :user => user, :url => "http://www.example.com/login" 
  end 
  
  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    ###
    ##
    #
    from          "Password Reset <noreply@example.com>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
end

