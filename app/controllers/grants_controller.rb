class GrantsController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :update]
  before_filter :verify_authenticity_token
  before_filter :store_location
  
  def index
    if params[:group_id]
      @grants = Group.find_by_permalink(params[:group_id]).grants.chronological        

    elsif params[:user_id]
      @grants = Grant.find_all_by_user_id(params[:user_id], 
                                            :order => "created_at ASC")
    end
  end
  
  def show
    @grant = Grant.find_by_permalink(params[:id])
  end
  
  def new
    @grant = Grant.new
  end
  
  def create
    @grant = current_user.grants.build(params[:grant])
    
    if @grant.save
     flash[:notice] =  "Grant created. "
     redirect_to group_grant_path(@grant.group, @grant)
    else
      render :action => "new"
    end
  end
    
  def edit
    @grant = Grant.find_by_permalink(params[:id])
  end
  
  def update
    @grant = Grant.find_by_permalink(params[:id])

    respond_to do |format|
      if @grant.update_attributes(params[:grant])
        flash[:notice] = 'Grant updated. '
        format.html { redirect_to group_grant_path(@grant.group, @grant) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

private
  def destroy
  end  
  
end

