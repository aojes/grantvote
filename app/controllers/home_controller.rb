class HomeController < ApplicationController
  before_filter :require_user, :only => [:show]

  def index
    @page_title = "Grantvote"
  end  
  
  def show
    @page_title = "Welcome"
    
  end
end
