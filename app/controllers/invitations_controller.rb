class InvitationsController < ApplicationController
  before_filter :require_user, :except => [:index, :new, :create] 
  before_filter :verify_authenticity_token
  
  def index
    if current_user 
    # @page_title ="Manage Invitations"
    # @invitations = Invitation.find(:all)
        
    respond_to do |format|
     # format.html { redirect_to(invitations_url) }
     format.html { redirect_to account_url  }
    end
    
    else
    @page_title = "Grantvote"

    end
    
  end
  
  def new
    @page_title ="Grantvote"
    @invitation = Invitation.new
  end
  
  def create
  
   @invitation = Invitation.new(params[:invitation])
   @invitation.sender = current_user
    if @invitation.save
      if current_user 
       Mailer.deliver_invitation(@invitation, signup_url(@invitation.token))
        flash[:notice] = "Thank you, invitation sent."
       
       redirect_to root_url
       
       else 
        flash[:notice] = "Thank you, we'll send you an invitation soon"
        redirect_to root_url
       end

    else
      render :action => 'new'
    end
    
  end
  
  
  
  def show
      @invitation = Invitation.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
  
  def self.send_invites
    
    Invitation.find(:all).each do | i |
     if i.sender_id.nil?
     @invitation = i
     #@invitation.sender = current_user
     i.update_attribute(:sender_id, 1)
     
     Mailer.deliver_invitation(@invitation, signup_url(@invitation.token))
     end
    end
  
  end
  
  
end
