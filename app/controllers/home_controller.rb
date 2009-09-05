class HomeController < ApplicationController

  def index
    @page_title = 'Grantvote'
  end

  def show
    @page_title = 'Welcome to Grantvote'
    if current_user
      @communications = current_user.friendships.map do |friendship|
          if friendship.friend.friendships.exists?(:friend_id => current_user)
            friendship.friend.communications
          end
        end.concat(current_user.communications).compact.flatten.
          sort_by(&:created_at).reverse.
            paginate(:page => params[:page], :per_page => 20)
    end

  end

end

