class HomeController < ApplicationController
  before_filter :require_user, :only => [:show]

  def index
    @page_title = 'Grantvote'
  end

  def show    
    @page_title = 'Welcome'

    @communications = current_user.friendships.map do |friendship|
        if friendship.friend.friendships.exists?(:friend_id => current_user)
          friendship.friend.communications
        end
      end.concat(current_user.communications).compact.flatten.
        sort_by(&:created_at).reverse.
          paginate(:page => params[:page], :per_page => 5)

  end

end

