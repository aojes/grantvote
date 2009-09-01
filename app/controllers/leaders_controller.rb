class LeadersController < ApplicationController

  # require user for private production
  before_filter :require_user
  def index
    @page_title = "Grantvote Leaders"

    @search = Credit.leaders.search(params[:search])
    @leaders = @search.all.paginate(:page => params[:page], :per_page => 5)

  end

end

