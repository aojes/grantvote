class FriendshipsController < ApplicationController
  before_filter :require_user

  def create
    @friendship = current_user.friendships.
                               build(:friend_id => params[:friend_id])
    if @friendship.save
      flash[:notice] = "Added friendship"
      redirect_back_or_default :back
    else
      flash[:error] = "Bleep, bloop. System error. Please try again."
      redirect_back_or_default :back
    end
  end

  def destroy
    @friendship = current_user.friendships.find_by_friend_id(params[:id])
    @friendship.destroy
    flash[:notice] = "Removed friendship"
    # !
    redirect_to profile_path(current_user.login)
  end

end
