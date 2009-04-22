class GrantsController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :update]
  before_filter :verify_authenticity_token

  def index
    if params[:group_id]
      @grants = Grant.find_all_by_group_id(params[:group_id], 
                                            :order => "created_at ASC")

    elsif params[:user_id]
      @grants = Grant.find_all_by_user_id(params[:user_id], 
                                            :order => "created_at ASC")
    end
  end
  
  def show
    @grant = Grant.find(params[:id])
  end
  
  def new
    @grant = Grant.new
  end
  
  def create
    @grant = current_user.grants.build(params[:grant])

    if @grant.save
     flash[:notice] =  "Grant was successfully created."
     redirect_to group_grant_path(@grant.group, @grant)
    else
      render :action => "new"
    end
  end
    
  def edit
    @grant = Grant.find(params[:id])
  end
  
  def update
    @grant = Grant.find(params[:id])

    respond_to do |format|
      if @grant.update_attributes(params[:grant])
        flash[:notice] = 'Grant was successfully updated.'
        format.html { redirect_to group_grant_path(@grant.group, @grant) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
end

