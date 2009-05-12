class LeadersController < ApplicationController
  require 'searchlogic'
  # require user for private production
  before_filter :require_user
  def index
    @page_title = "Grantvote Leaders"

    @search = Credit.leaders.new_search(params[:search])
    @search.per_page = 5
    @leaders, @leaders_count = @search.all, @search.count
  
  end
  
end
