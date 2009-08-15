class BlitzesController < ApplicationController

  before_filter :require_user # for all private beta
  before_filter :verify_authenticity_token
  
  def index
    @page_title = "Grantvote Blitz"
    @general_pool = BlitzFund.find_by_dues(Payment::AMOUNT).general_pool

    session[:group_id] = 0
    
    @search = Blitz.search(params[:search])
    @blitzes = @search.all.reject {|b| !(b.votes.count.zero? && b.awarded) }.
      paginate(:page => params[:page])

    session[:group_permalink] = 0 # set to 0 for blitz payment
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

    # TODO refactor to model & protect blitz votes
    blitz_fund = BlitzFund.find_by_dues(Payment::AMOUNT)
    @blitz.blitz_fund_id = blitz_fund.id
    @blitz.votes_win = 1 + @blitz.amount / Payment::AMOUNT  
    
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


