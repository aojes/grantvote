namespace :db do
  desc "Send invitations"
  
  task :send_invites => :environment do
  @invitations = Invitation.find(:all)
  
  @invitations.each do | i |
  
     if i.sender_id.nil?
     @invitation = i
     @invitation.sender = 1
     
     Mailer.deliver_invitation(@invitation, signup_url(@invitation.token))
    # i.update_attribute(:sender_id, '1')
    # i.update_attribute(:sent_at, Time.now)

     end
  end
  
  
  
  end
  
end
