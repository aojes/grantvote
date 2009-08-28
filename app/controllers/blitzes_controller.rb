class BlitzesController < ApplicationController

  before_filter :require_user # for all private beta
  before_filter :verify_authenticity_token

  def index
    @page_title = 'Grantvote Blitz'
    blitz_fund = BlitzFund.find_by_dues(Payment::AMOUNT)
    @awards = blitz_fund.awards
    @general_pool = blitz_fund.general_pool

    session[:group_id] = 0
    session[:group_permalink] = 0 # set to 0 for blitz payment
    @blitzes = Blitz.session.reject do |b|
                 !b.votes.
                 count(:conditions => {:user_id => current_user.id}).zero?
               end.paginate(:page => params[:page], :per_page => 10)
#    @blitzes = Blitz.search(
#                 params[:search],
#                 :match_mode    => :boolean,
#                 :field_weights => { :name => 12, :proposal => 10 }
#               ).reject { |b| b.awarded }.reject do |b|
#                   !b.votes.
#                     count(:conditions => {:user_id => current_user.id}).zero?
#                 end.paginate(:page => params[:page], :per_page => 10)
#    @search = Blitz.search(params[:search])
#    @blitzes = @search.all.reject { |b| b.awarded }.
#      reject do |b|
#        !b.votes.
#        count(:conditions => {:user_id => current_user.id}).zero?
#      end.paginate(:page => params[:page], :per_page => 10)


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

    ##
    # Loses!
    # @blitz.votes_win = 1 + @blitz.amount / Payment::AMOUNT

    @blitz.votes_win = Blitz.set_votes_win

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

