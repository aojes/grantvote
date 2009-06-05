class GrantsController < ApplicationController
  require 'searchlogic'
  
  # require user for private production
  before_filter :require_user# , :only => [:new, :create, :update]
  before_filter :verify_authenticity_token
  
  def index
    if params[:group_id]

      @group = Group.find_by_permalink(params[:group_id])
      @page_title = "Voting Session for " + @group.name

      @search = @group.grants.new_search(params[:search])

      @search.conditions.final = false
      @search.per_page = 10
      @search.order_as = "ASC"
      @search.order_by = :created_at
    
      @grants = @search.all
      @grants_count = @search.count                          
                          
    elsif params[:user_id]
      @grants = Grant.find_all_by_user_id(params[:user_id], 
                                            :order => "created_at ASC")
      @page_title = "Listing Grants"                                            
    else
      @page_title = "Grants on Grantvote"

      @search = Grant.new_search(params[:search])
      
      if params[:search]
        if params[:search][:conditions]
          query = params[:search][:conditions][:proposal_keywords].split
        
          @search.conditions.or_group do |g|
            g.proposal_keywords = query
           # FIXME g.or_name_keywords = query
          end 
        end
      end  
      @search.per_page = 10
      @search.order_by, @search.order_as = [:updated_at], 'DESC'
      @search.conditions.final = true
      @search.conditions.awarded = true
      @search.per_page = 10

      @grants, @grants_count = @search.all, @search.count
    end
    respond_to do |format|
      format.html # index.html.erb
    end    
  end
  
  def show
    @grant = Grant.find_by_permalink(params[:id])
    @page_title = @grant.name + " on Grantvote"
  end
  
  def new
    @page_title = "New Grant"
    @grant = Grant.new
  end
  
  def create
    @grant = current_user.grants.build(params[:grant])
    
    if @grant.save
      flash[:notice] =  "Grant created. "
      redirect_to group_grant_path(@grant.group, @grant)
    else
      render :action => :new
    end
  end
    
  def edit
    @grant = Grant.find_by_permalink(params[:id])
    @page_title = "Editing " + @grant.name
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
  
end

