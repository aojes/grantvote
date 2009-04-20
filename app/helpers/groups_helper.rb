module GroupsHelper

  def grants_awarded
    Grant.find_all_by_group_id_and_awarded(params[:id], true, 
                                              :order => "updated_at DESC")
  end

  def member?(group_id)
    Membership.exists?(:user_id => current_user, :group_id => group_id)
  end
  
  def group_members(group_id)
    User.find(Group.find(group_id).memberships.members.collect {|m| m.user_id })
  end

  def voter?(group_id)
    Membership.exists?(:user_id => current_user, :group_id => group_id,
                                                      :interest => true)
  end
  
  def group_voters(group_id)
    User.find(Group.find(group_id).memberships.voters.collect {|m| m.user_id })
  end     
end
