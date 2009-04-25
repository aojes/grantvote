class MembershipsController < ApplicationController
  before_filter :require_user
  
  def new
    @membership = Membership.new
  end
  
  def create
    @membership = Membership.new(params[:membership])

    respond_to do |format|
      if @membership.save
        flash[:notice] = 'Membership successfully created.'
        format.html { redirect_to group_path(Group.find_by_permalink(params[:group_id])) }
      else
        format.html { redirect_back_or_default :back }
      end
    end
  end
    
  
  
end
