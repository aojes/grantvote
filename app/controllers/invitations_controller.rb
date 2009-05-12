class InvitationsController < ApplicationController
  before_filter :require_no_user
  before_filter :verify_authenticity_token
  
  def create
    @invitation = Invitation.new(params[:invitation])
    
    if @invitation.save
      flash[:notice] =  "Please allow some time to prepare an invitation.  " +
                       "Thank you for your interest.  See you soon!"
      redirect_to :back
    else
      redirect_to root_path
    end
  end
  
end
