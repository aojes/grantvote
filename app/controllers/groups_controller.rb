class GroupsController < ApplicationController

  # require user for private production
  before_filter :require_user, :except => [:index, :show]
  before_filter :verify_authenticity_token

  def index
    @page_title = 'Grantvote'
    unless params[:search].blank?
      @groups = Group.search(
                  params[:search],
                  :match_mode    => :boolean,
                  :field_weights => { :name => 20, :purpose => 10 }
                ).paginate(:page => params[:page], :per_page => 10)
    else
      @groups = Group.all.sort{ |a,b| b.funds <=> a.funds }.
        paginate(:page => params[:page], :per_page => 10)
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @group = Group.find_by_permalink(params[:id])
    @page_title = @group.name + ' on Grantvote'

    @grants = @group.grants.awarded.recent.reverse.
      paginate(:page => params[:page], :per_page => 10)
    @comments = @group.comments.reverse.
                         paginate(:page => params[:comments], :per_page => 8)
    session[:group_id] = @group.id
    respond_to do |format|
      format.html
    end
  end

  def new
    @page_title = "New Group on Grantvote"
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @group = Group.find_by_permalink(params[:id])
    @page_title = "Editing #{@group.name} "    # TODO safe call?
    session[:group_id] = @group.id
    respond_to do |format|
      if @group.authorize_edit?(current_user)
        format.html
      else
        format.html { redirect_back_or_default :back }
      end
    end
  end

  def create
    @group = Group.new(params[:group])
    @group.memberships.build(:user => current_user, :interest => false,
                                                    :role => "creator")
    # TODO assign pebble on dues paid
    respond_to do |format|
      if @group.save
        flash[:notice] = 'Created group. '
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
        flash[:notice] = 'Updated group. '
        format.html { redirect_to(@group) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

end

