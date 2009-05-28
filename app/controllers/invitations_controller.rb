class InvitationsController < ApplicationController
  before_filter :require_user, :except => [:index, :new, :create] 
  before_filter :verify_authenticity_token
  
  def index
    if current_user 
     @page_title ="Manage Invitations"
     @invitations = Invitation.find(:all)
    
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
    #@invitation.sender = current_user
    
    if @invitation.save

        flash[:notice] = "Thank you, we'll send you an invitation soon"
       redirect_to root_path

    else
      render :action => 'new'
    end
    
  end
  
  
  def send_invitation
   @invitation = Invitation.find(params[:id])
   Mailer.deliver_invitation(@invitation, invitations_url(@invitation.token))
  
    respond_to do |format|
      format.html { redirect_to(invitations_url) }
    end
    
  end
  
  def show
      @invitation = Invitation.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
  
  
end
