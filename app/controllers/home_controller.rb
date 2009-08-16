class HomeController < ApplicationController
  before_filter :require_user, :only => [:show]

  def index
    @page_title = "Grantvote"
  end  
  
  def show
    @page_title = "Welcome"
    @communications = Communication.find_all_by_user_id(current_user.id).
      reverse
  end
end
