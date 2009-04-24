module GroupsHelper

  def grants_awarded
    Grant.find_all_by_permalink_and_awarded(params[:id], true, 
                                              :order => "updated_at DESC")
  end
  
  def member?(group_id)
    Membership.exists?(:user_id => current_user, :group_id => find_group_id(group_id))
  end
  
  def group_members(group_id)
    User.find(Group.find_by_permalink(group_id).
                memberships.members.collect {|m| m.user_id })
  end

  def voter?(group_id)
    Membership.exists?(:user_id => current_user, :group_id => find_group_id(group_id),
                                                      :interest => true)
  end
  
  def group_voters(group_id)
    User.find(Group.find_by_permalink(group_id).
                memberships.voters.collect {|m| m.user_id })
  end     
 
  def session_award_time(grant)
    # make chart as such for later
    # == simple line chart at votes on duration of time
    # 
    # http://chart.apis.google.com/chart?cht=lc&chs=92x50&chco=224499
    # &chd=t:20,30,40,50,60,70,80,90,100&chm=B,80C65A,0,0,0&chtt=session+time
    distance_of_time_in_words grant.created_at, grant.updated_at, true
  end  
  
end
