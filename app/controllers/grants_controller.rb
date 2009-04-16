class GrantsController < ApplicationController
  before_filter :require_user
  before_filter :verify_authenticity_token

  def index
    if params[:group_id]
      @group  = Group.find(params[:group_id])
      @grants = Grant.find_all_by_group_id(params[:group_id], 
                                            :order => "created_at ASC")
    elsif params[:user_id]
#      @grants = Grant.find_all_by_user_id(params[:user_id], 
#                                            :order => "created_at ASC")
    end
  end
  
  def show
    @grant = Grant.find(params[:id])
  end
  
  def new
    @grant = Grant.new
  end
  
  def create
    @grant = Grant.new(params[:grant])

    # Really baffled here
#    @grant.votes << Vote.new(:user_id   => current_user.id,
#                             :group_id  => params[:grant][:group_id],
#    :authority => Membership.find_by_user_id_and_group_id(current_user.id, 
#                                      params[:grant][:group_id]).authority,
#                             :cast => "yea")

    @vote = Vote.new(:user_id   => current_user.id,
                             :group_id  => params[:grant][:group_id],
                             :cast => "yea")

    respond_to do |format|
      if @grant.save
        @vote.grant_id = @grant.id # TODO fixme
        @vote.save                 #
        flash[:notice] = 'Grant was successfully created.'
        
        format.html { redirect_to @grant.group }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def edit
    @grant = Grant.find(params[:id])
  end
  
  def update
  
  end
  
end

