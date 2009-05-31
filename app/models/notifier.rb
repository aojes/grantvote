class Notifier < ActionMailer::Base
  
  default_url_options[:host] = "www.grantvote.com"
  
  def welcome_email(user)  
    recipients    user.email 
    from          "Grantvote <tefflox@gmail.com>"  
    subject       "Welcome to Granvote"  
    sent_on       Time.now 
    body          :user => user, :url => "http://www.grantvote.com/login" 
  end 
  
  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    ###
    ##
    #
    from          "Grantvote <noreply@grantvote.com>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
end

