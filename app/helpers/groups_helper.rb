module GroupsHelper

  def grants_awarded
    Grant.find_all_by_group_id_and_awarded(params[:id], true, 
                                              :order => "updated_at DESC")
  end
    
end
