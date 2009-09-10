class BlitzesController < ApplicationController

  before_filter :require_user, :except => [:index, :show]
  before_filter :verify_authenticity_token

  def index
    @page_title = 'Grantvote Blitz'
    blitz_fund = BlitzFund.find_or_create_by_dues(Payment::DIVIDEND)
    @awards = blitz_fund.awards
    @general_pool = blitz_fund.general_pool

    session[:group_id] = 0
    session[:group_permalink] = 0 # set to 0 for blitz payment

    if current_user
      @blitzes = Blitz.session.reject do |b|
                   !b.votes.
                   count(:conditions => {:user_id => current_user.id}).zero?
                 end.paginate(:page => params[:page], :per_page => 10)
    else
      @blitzes = Blitz.session.paginate(:page => params[:page], :per_page => 10)
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @blitz = Blitz.find_by_permalink(params[:id])
    @page_title = @blitz.name + " on Blitzvote Blitz"
    session[:group_id] = 0
  end

  def new
    @page_title = "New Blitz Grant"
    @blitz = Blitz.new
    session[:group_id] = 0
  end

  def create
    @blitz = current_user.blitzes.build(params[:blitz])

    # TODO refactor to model & protect blitz votes
    blitz_fund = BlitzFund.find_by_dues(Payment::DIVIDEND)
    @blitz.blitz_fund_id = blitz_fund.id

    ##
    # Loses!
    # @blitz.votes_win = 1 + @blitz.amount / Payment::AMOUNT

    @blitz.votes_win = Blitz.set_votes_win
    session[:group_id] = 0
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
    session[:group_id] = 0
  end

  def update
    @blitz = Blitz.find_by_permalink(params[:id])
    session[:group_id] = 0
    respond_to do |format|
      if @blitz.update_attributes(params[:blitz])
        flash[:notice] = 'Updated blitz grant '
        format.html { redirect_to blitz_path(@blitz) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @blitz = Blitz.find_by_permalink(params[:id])
    @blitz.destroy
    session[:group_id] = 0
    respond_to do |format|
      flash[:notice] = 'Adios.'
      format.html { redirect_to blitzes_path }
    end
  end

end

