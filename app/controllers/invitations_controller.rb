class InvitationsController < ApplicationController
  before_filter :require_user, :except => [:index, :new, :create] 
  before_filter :verify_authenticity_token
  
  def index
    @page_title = "Grantvote"
  end
  
  def new
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
  
  def list
  
  @invitations = Invitation.find(:all)
  
  end
  
  def show
  
  end
  
  private 
  
  def send_invitation
  # Mailer.deliver_invitation(@invitation, signup_url(@invitation.token))
  
  end
  
  
end
