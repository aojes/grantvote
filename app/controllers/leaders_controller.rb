class LeadersController < ApplicationController
  require 'searchlogic'
  
  def index
    @page_title = "Grantvote Leaders"

    @search = Credit.leaders.new_search(params[:search]

    @search.per_page = 10

    # TODO display on grants awarded and credit on the site 
#    
#    @grants_awarded = @search.all

#    @grants_awarded_count = @search.count
  end
  
end
