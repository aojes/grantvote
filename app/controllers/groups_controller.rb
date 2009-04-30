class GroupsController < ApplicationController
  require 'searchlogic'

  before_filter :require_user, :except => [:index, :show]
  before_filter :verify_authenticity_token
  
  def index
    
    @search = Group.new_search(params[:search])
    
    if params[:search]
      if params[:search][:conditions]
        query = params[:search][:conditions][:name_keywords].split
      
        @search.conditions.or_group do |g|
          g.name_keywords = query
          g.or_purpose_keywords = query
        end
      end
    end  
    @search.per_page = 10
    @groups, @groups_count = @search.all, @search.count
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @group = Group.find_by_permalink(params[:id])
    
    @search = @group.grants.new_search(params[:search])

    @search.conditions.final = true
    @search.per_page = 10
    @search.order_as = "ASC"
    @search.order_by = :updated_at
    
    @grants_awarded = @search.all

    @grants_awarded_count = @search.count

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @group = Group.find_by_permalink(params[:id])
    
    respond_to do |format|
      if Membership.exists?(:user_id => current_user.id, 
                                :group_id => @group.id,
                                :interest => true, :role => "moderator")
        format.html
      else
        format.html { redirect_back_or_default :back }
      end
    end                      
  end

  def create
    @group = Group.new(params[:group])
    @group.memberships.build(:user => current_user, :interest => true,
                                                    :role => "moderator")
    # TODO assign pebble on dues paid
    respond_to do |format|
      if @group.save
        flash[:notice] = 'Group created. '
        format.html { redirect_to(@group) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def update
    @group = Group.find_by_permalink(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = 'Group updated. '
        format.html { redirect_to(@group) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

private

#  def destroy
#    @group = Group.find_by_permalink(params[:id])
#    @group.destroy

#    respond_to do |format|
#      format.html { redirect_to(groups_url) }
#      format.xml  { head :ok }
#    end
#  end
  
end
