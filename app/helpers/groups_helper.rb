module GroupsHelper

  def member?
    Membership.exists? :user_id => current_user, :group_id => params[:id] 
  end
  
  def principals
    User.find(Membership.find_all_by_group_id_and_principal(params[:id], true))
  end
  
end
