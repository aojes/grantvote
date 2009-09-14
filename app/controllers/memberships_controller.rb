class MembershipsController < ApplicationController
  before_filter :require_user
  before_filter :verify_authenticity_token

  def new
    @page_title = "New Membership"
    @membership = Membership.new
    session[:group_id] = Group.find_by_permalink(params[:group_id]).id
    session[:group_permalink] = params[:group_id]
  end

  def create
    @group = Group.find_by_permalink(params[:group_id])
    @membership = Membership.new
    @membership.user_id  = current_user.id
    @membership.group_id = @group.id
    @membership.interest = false
    @membership.role = @group.memberships.count.zero? ?
                       @group.voters_count.zero?      ? 
                                            'creator' : 'moderator' : 'basic'

    respond_to do |format|
      if @membership.save
        flash[:notice] = 'Membership created.'
        format.html { redirect_to group_path(@membership.group) }
      else
        format.html { redirect_back_or_default :back }
      end
    end
  end

end

