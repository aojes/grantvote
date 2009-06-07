class InvitationsController < ApplicationController
  before_filter :require_user, :except => [:index, :new, :create] 
  before_filter :verify_authenticity_token
  
  def index
    if current_user 
      # @page_title ="Manage Invitations"
      # @invitations = Invitation.find(:all)
        
      respond_to do |format|
        # format.html { redirect_to(invitations_url) }
        format.html { redirect_to profile_path(current_user.login)  }
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
    if @invitation.save and params[:invitation] 
      if current_user and params[:invitation] 
        Mailer.deliver_invitation(@invitation, signup_url(@invitation.token))
       
        flash[:notice] = "Thank you, invitation sent."
        respond_to do |format|
          format.html { redirect_to profile_path(current_user.login)  }
          format.js 
        end
      else 
        flash[:notice] = "Thank you, we'll send you an invitation soon"
        
        redirect_to root_url
      end
    elsif current_user
       redirect_to root_url
    else
      render :action => :new
    end
  end
  
  def approve_invitations
  
    if current_user.id == 1
      @invitation = Invitation.find(:all)
    else
      redirect_to root_url
    end
  end
  
  def send_invite
    @invitation  = Invitation.find(params[:id])

    @invitation.sender = current_user
    Mailer.deliver_invitation(@invitation, signup_url(@invitation.token))
    
    respond_to do |format|
      # format.html { redirect_to(invitations_url) }
      format.html { redirect_to profile_path(current_user.login)  }
    end
  end
  
  
  
  def self.send_all_invites
    
    Invitation.find(:all).each do | i |
      if i.sender_id.nil?
        @invitation = i
        @invitation.sender = current_user
        
        #i.update_attribute(:sender_id, 1)
        Mailer.deliver_invitation(@invitation, signup_url(@invitation.token))
      end
    end
  end
  
end
