# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Sets the page title and outputs title if container is passed in.
  # eg. <%= title('Hello World', :h2) %> will return the following:
  # <h2>Hello World</h2> as well as setting the page title.
  def title(str, container = nil)
    @page_title = str
    content_tag(container, str) if container
  end
    
  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, html_escape(flash[msg.to_sym]), :id => "flash-#{msg}") unless flash[msg.to_sym].blank?
    end
    messages
  end
  

  def member?(group_id)
    Membership.exists?(:user_id => current_user, :group_id => group_id)
  end
  
  def members(group_id)
    User.find(Membership.find_all_by_group_id(group_id).
                collect { |m| m.user_id })
  end

  def principal?(group_id)
    Membership.exists?(:user_id => current_user, :group_id => group_id,
                                                      :interest => true)
  end
  
  def principals(group_id)
    User.find(Membership.find_all_by_group_id_and_interest(group_id, true).
                collect { |u| u.user_id })
  end
  
   
end
