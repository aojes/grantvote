class GroupsController < ApplicationController
  require 'searchlogic'

  before_filter :require_user, :except => [:index, :show]
  before_filter :verify_authenticity_token
  
  def index
    
    @search = Group.new_search(params[:search])
    
    if params[:search]
      query = params[:search][:conditions][:name_keywords].split
      
      @search.conditions.or_group do |g|
        g.name_keywords = query
        g.purpose_keywords = query
      end
      @search.per_page = 10

      
    else
      # will_paginate @groups, by popularity and solvency
    end
    @groups, @groups_count = @search.all, @search.count
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

  def destroy
    @group = Group.find_by_permalink(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end
  
end
