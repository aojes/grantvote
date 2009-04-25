class VotesController < ApplicationController
  before_filter :require_user
  before_filter :verify_authenticity_token
  
  def create
    @vote = Vote.new(params[:vote])

    respond_to do |format|
      if @vote.save
        flash[:notice] = @vote.final_message or "Vote cast successfully."
        format.html { redirect_to :back }
      else
        flash[:notice] = @vote.fail_message or "Please try again."
        format.html { redirect_to :back }
      end
    end
  end
  
end
