class VotesController < ApplicationController
  before_filter :require_user
  before_filter :verify_authenticity_token
  
  def create
    @vote = Vote.new(params[:vote])

    respond_to do |format|
      if @vote.save
        final = @vote.final_message
        flash[:notice] = final ? final : "Voted successfully."
        format.html { redirect_back_or_default :back }
      else
        limit = @vote.session_limit_message 
        flash[:notice] = limit ? limit : "Bleep, bloop. Please try again."
        format.html { redirect_to :back }
      end
    end
  end
  
end
