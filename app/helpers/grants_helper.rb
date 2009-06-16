module GrantsHelper
  
  def voted?(grant)
    Vote.exists?(:grant_id => grant.id, :user_id => current_user.id)
  end
  
  def award_total
    Grant.find_all_by_awarded(true).collect {|g| g.amount}.sum
  end
  
end
