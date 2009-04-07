module GroupsHelper

  def member
    Membership.exists? :user_id => current_user, :group_id => params[:id] 
  end
end
