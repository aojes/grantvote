module BlitzesHelper
 
  def voting_blitz?(blitz)
    not Vote.exists?(:blitz_id => blitz, :user_id => current_user)
  end
  
  def voted_blitz?(blitz)
    Vote.exists?(:blitz_id => blitz.id, :user_id => current_user.id)
  end
  
  def show_blitz?(blitz)
    blitz.votes.count > 0 and 
    not current_user == blitz.user and 
    not blitz.votes.exists?(:user_id => current_user)
  end
end
