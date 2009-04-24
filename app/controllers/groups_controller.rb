class GroupsController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  
  def index
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @group = Group.find_by_permalink(params[:id])

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
  end

  def create
    @group = Group.new(params[:group])
    @group.memberships.build(:user => current_user, :interest => false)
    respond_to do |format|
      if @group.save
        flash[:notice] = 'Group was successfully created.'
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
        flash[:notice] = 'Group was successfully updated.'
        format.html { redirect_to(@group) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

private

  def destroy
    @group = Group.find_by_permalink(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end
  
end
