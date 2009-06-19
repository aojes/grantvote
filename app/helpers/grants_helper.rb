module GrantsHelper
  
  def voted?(grant)
    Vote.exists?(:grant_id => grant.id, :user_id => current_user.id)
  end
  
  def show_grant?(grant)
    not voted?(grant) and not grant.votes.count.zero?
  end
  
end
