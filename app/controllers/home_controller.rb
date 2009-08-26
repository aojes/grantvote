class HomeController < ApplicationController
  before_filter :require_user, :only => [:show]

  def index
    @page_title = 'Grantvote'
  end

  def show
    @page_title = 'Welcome'
#    @communications = Communication.find_all_by_user_id(current_user).
#      reverse
    @communications = current_user.friendships.map do |friendship|
        if friendship.friend.friendships.exists?(:friend_id => current_user)
          friendship.friend.communications
        end
      end.flatten.
        concat(current_user.communications).flatten.
          sort{ |a,b| b.created_at <=> a.created_at}.
            paginate(:page => params[:page], :per_page => 5)

  end

end

