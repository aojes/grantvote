class LeadersController < ApplicationController
  require 'searchlogic'
  
  def index
    @page_title = "Grantvote Leaders"

    @search = Credit.leaders.new_search(params[:search])
    @search.per_page = 10
    @leaders, @leaders_count = @search.all, @search.count

    # TODO display on grants awarded and credit on the site 
    
  end
  
end
