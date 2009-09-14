class GrantsController < ApplicationController

  # require user for private production
  before_filter :require_user, :except => [:index, :show]
  before_filter :verify_authenticity_token

  def index
    if params[:group_id]

       @group = Group.find_by_permalink(params[:group_id])
       @page_title = "Voting Session for " + @group.name
       @grants = @group.grants.session.chronological.
         paginate(:page => params[:page], :per_page => 10)
       session[:group_id] = @group.id
    elsif params[:user_id] # FIXME not used !
      @grants = Grant.find_all_by_user_id(params[:user_id],
                                            :order => "created_at ASC")
      @page_title = 'Listing Grants'
    else # Grants#index
      @page_title = 'Recent Awards on Grantvote'

      if !params[:search].blank?
        @grants = Grant.search(
                    params[:search],
                    :match_mode    => :boolean,
                    :field_weights => { :name => 20, :proposal => 10},
                    :with          => { :awarded => true }
                  ).concat(Blitz.search(
                      params[:search],
                      :match_mode    => :boolean,
                      :field_weights => { :name => 20, :proposal => 10},
                      :with          => { :awarded => true })
                  ).paginate(:page => params[:page], :per_page => 10)
      else

        grants  = Grant.find_all_by_awarded(true)
        blitzes = Blitz.find_all_by_awarded(true)

        @grants = grants.concat(blitzes).
          sort {|a, b| b.updated_at <=> a.updated_at }.
            paginate(:page => params[:page], :per_page => 10)
      end
    end
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @grant = Grant.find_by_permalink(params[:id])
    @page_title = @grant.name + ' on Grantvote'
    session[:group_id] = @grant.group.id
  end

  def new
    @page_title = "New Grant"
    @grant = Grant.new
    @group = Group.find_by_permalink(params[:group_id])
  end

  def create
    @grant = current_user.grants.build(params[:grant])
    @grant.user_id = current_user
    @group = Group.find_by_permalink(params[:group_id])
    @grant.group_id = @group.id

    if @grant.save
      flash[:notice] =  "Grant created. "
      redirect_to group_grant_path(@grant.group, @grant)
    else
      render :action => :new
    end
  end

  def edit
    @grant = Grant.find_by_permalink(params[:id])
    @group = @grant.group
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

  def destroy
    @grant = Grant.find_by_permalink(params[:id])
    @group = @grant.group
    @grant.destroy

    respond_to do |format|
      flash[:notice] = 'Grant deleted.'
      format.html { redirect_to @group }
    end
  end

end

