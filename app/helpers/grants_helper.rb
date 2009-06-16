module GrantsHelper
  
  def voted?(grant)
    Vote.exists?(:grant_id => grant.id, :user_id => current_user.id)
  end
  
  def show_grant?(grant)
    !(voted?(grant) and grant.user == current_user and grant.votes.count.zero?)
  end
  
end
