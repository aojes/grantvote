class CommentsController < ApplicationController
  before_filter :require_user
  before_filter :verify_authenticity_token

  def index
    @page_title = "Listing Comments"
    @commentable = find_commentable
    @comments = @commentable.comments
  end

  def new
    group      = Group.find_by_permalink(params[:group_id])
    membership = Membership.exists?(:user_id => current_user.id,
                                                    :group_id => group.id)
    if membership
      @page_title = "New Comment"
      @commentable = find_commentable
    else
      flash[:notice] = "Please join the group before commenting"
      redirect_to new_group_membership_path(group)
    end
  end

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])

    if @comment.save
      flash[:notice] = "Comment created. "
      case @comment.commentable_type
        when "Group"
          redirect_to group_path(Group.find(@comment.commentable_id)) # FIXME?
        else
          redirect_to :id => nil
      end
    else
      flash[:notice] = 'Bleep, bloop.  Please try again.'
      render :action => 'new'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_back_or_default :back }
    end
  end

  private

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find_by_permalink(value)
      end
    end
    nil
  end
end

