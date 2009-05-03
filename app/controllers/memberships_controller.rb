class MembershipsController < ApplicationController
  before_filter :require_user
  before_filter :verify_authenticity_token
  
  def new
    @page_title = "New Membership"
    @membership = Membership.new
  end
  
  def create
    @membership = Membership.new(params[:membership])

    respond_to do |format|
      if @membership.save
        flash[:notice] = 'Membership created.'
        format.html { redirect_to group_path(@membership.group) }
      else
        format.html { redirect_back_or_default :back }
      end
    end
  end
    
  
  
end
