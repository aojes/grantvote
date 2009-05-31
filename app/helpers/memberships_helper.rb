module MembershipsHelper
  def watching?(group_id, user)
    Membership.find_by_user_id_and_group_id_and_interest(
                   user.id, group_id, false).nil?
  end
end
