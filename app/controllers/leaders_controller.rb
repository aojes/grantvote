class LeadersController < ApplicationController

  def index
    @page_title = "Grantvote Leaders"

    @search = Credit.leaders.search(params[:search])
    @leaders = @search.all.paginate(:page => params[:page], :per_page => 5)

  end

end

