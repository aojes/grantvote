module BlitzesHelper
 
  def voting?(blitz)
    Vote.exists?(:blitz_id => blitz, :user_id => current_user).nil?
  end
 
  def show_blitz?(blitz)
    blitz.votes.count > 0 and 
    not current_user == blitz.user and 
    not blitz.votes.exists?(:user_id => current_user.id)
  end
end
