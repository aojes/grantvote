class MembershipsController < ApplicationController
  before_filter :require_user
  
  def new
    @membership = Membership.new
  end
  
  def create
    @membership = Membership.new(params[:membership])
    respond_to do |format|
      if @membership.save
        flash[:notice] = 'Membership was successfully created.'
        format.html { redirect_back_or_default :back }
      else
        format.html { redirect_back_or_default :back }
      end
    end
  end
    
  
  
end
