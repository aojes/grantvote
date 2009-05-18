class Notifier < ActionMailer::Base
  ###
  ##
  #
  default_url_options[:host] = "authlogic_example.binarylogic.com"
  
  def welcome_email(user)  
    recipients    user.email 
    from          "My Awesome Site Notifications <notifications@example.com>"  
    subject       "Welcome to My Awesome Site"  
    sent_on       Time.now 
    body          :user => user, :url => "http://example.com/login" 
  end 
  
  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    ###
    ##
    #
    from          "Binary Logic Notifier <noreply@binarylogic.com>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
end

