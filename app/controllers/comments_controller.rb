class CommentsController < ApplicationController
  before_filter :require_user  
  
  def index
    @commentable = find_commentable
    @comments = @commentable.comments
  end
  
  def new
    @commentable = find_commentable
  end
  
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])

    if @comment.save
      flash[:notice] = "Comment created."
      case @comment.commentable_type
        when "Group"
          redirect_to group_path(Group.find(@comment.commentable_id)) # FIXME?
        else
          redirect_to :id => nil  
      end
    else
      render :action => 'new'
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
