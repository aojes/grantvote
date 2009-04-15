class VotesController < ApplicationController
  before_filter :require_user
  before_filter :verify_authenticity_token
  
  def create
    @vote = Vote.new(params[:vote])
   
    if @vote.save
      respond_to do |format|
        flash[:notice] = "Vote cast successfully."
        format.html { redirect_to :back }
      end
    else
      respond_to do |format|
        flash[:notice] = "Please try again."
        format.html { redirect_to :back }
      end
    end
  end
  
end
