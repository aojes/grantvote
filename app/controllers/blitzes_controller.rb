class BlitzesController < ApplicationController

  before_filter :require_user # for all private beta
  before_filter :verify_authenticity_token
  
  def index
    @page_title = "Grantvote Blitz"
    @search = Blitz.new_search(params[:search])

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
    @search.conditions.final = false
    @search.order_by, @search.order_as = [:updated_at], 'DESC'
    # @search.conditions.final = true
    # @search.conditions.awarded = true
    @search.per_page = 10

    @blitzes, @blitzes_count = @search.all, @search.count
    respond_to do |format|
      format.html # index.html.erb
    end    
  end
  
  def show
    @blitz = Blitz.find_by_permalink(params[:id])
    @page_title = @blitz.name + " on Blitzvote Blitz"
  end
  
  def new
    @page_title = "New Blitz Grant"
    @blitz = Blitz.new
  end
  
  def create
    @blitz = current_user.blitzes.build(params[:blitz])
    
    ## FIXME
    @blitz.blitz_fund_id = 1 # for DUES = 5
    ##
    @blitz.votes_win = 1 + @blitz.amount / 5
    
    if @blitz.save
      flash[:notice] =  "Created blitz grant "
      redirect_to blitz_path(@blitz)
    else
      render :action => :new
    end
  end
    
  def edit
    @blitz = Blitz.find_by_permalink(params[:id])
    @page_title = "Editing " + @blitz.name
  end
  
  def update
    @blitz = Blitz.find_by_permalink(params[:id])

    respond_to do |format|
      if @blitz.update_attributes(params[:blitz])
        flash[:notice] = 'Updated blitz grant '
        format.html { redirect_to blitz_path(@blitz) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
end


