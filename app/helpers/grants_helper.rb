module GrantsHelper
  def voted?(grant)
    Vote.exists?(:grant_id => grant.id, :user_id => current_user.id)
  end
end
