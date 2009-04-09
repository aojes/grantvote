class GrantsController < ApplicationController
  before_filter :require_user
  
  def new
    @grant = Grant.new
  end
  
  def create
    @grant = Grant.new(params[:grant])

    respond_to do |format|
      if @grant.save
        flash[:notice] = 'Grant was successfully created.'
        format.html { redirect_to(Group.find(params[:group_id])) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
end
