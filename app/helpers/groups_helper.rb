module GroupsHelper
  
  def top_contributors(group_id)
    top_members = Membership.find_all_by_group_id(group_id, 
                          :order => "contributes DESC", :limit => 3).
                          collect {|u| u.user_id }
    User.find(top_members)
  end
  
  def grants_awarded
    find_group(params[:id]).grants.awarded.sort! { |a, b| 
                                            b.updated_at <=> a.created_at } 
  end
  
  def member?(group_id)
    Membership.exists?(:user_id => current_user, :group_id => find_group_id(group_id))
  end
  
  def group_members(group_id)
    User.find(Group.find_by_permalink(group_id).
                memberships.members.collect {|m| m.user_id })
  end

  def voter?(group_id)
    Membership.exists?(:user_id => current_user, 
                          :group_id => find_group_id(group_id),
                                                      :interest => true)
  end
  
  def creator?(user, group)
    Membership.exists?(:user_id => user, :group_id => @group, 
              :role => 'creator')
  end
  
  def moderator?(user, group)
    Membership.exists?(:user_id => user, :group_id => @group, 
              :role => 'moderator')  
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
  
  def voted_sessions(grants)
    count = 0
    grants.each do |g|
      count += 1 unless g.votes.count.zero?
    end
    count
  end
  
  def group_member?(group_id, user)
    not Membership.find_by_user_id_and_group_id(user.id, group_id).nil?
  end
  
  def watching?(group_id, user)
    Membership.exists?(:group_id => group_id, :user_id => user.id, 
                                                :interest => false)
  end
  
  def voting?(group_id, user)
    not Membership.find_by_user_id_and_group_id_and_interest(
                   user.id, group_id, true).nil?  
  end   
 
end
