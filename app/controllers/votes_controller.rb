class VotesController < ApplicationController
  before_filter :require_user
  before_filter :verify_authenticity_token
  
  def create
    @vote = Vote.new(params[:vote])

    respond_to do |format|
      if @vote.grant.group.solvent?
        if @vote.save
          final = @vote.final_message
          flash[:notice] = final ? final : "Voted successfully."
          format.html { redirect_to group_grant_path(@vote.group, @vote.grant) }
        else
          limit = @vote.limit_message 
          flash[:notice] = limit ? limit : "Bleep, bloop. Please try again."
          format.html { redirect_to group_grant_path(@vote.group, @vote.grant) }
        end
      else
        flash[:warning] = "Amount is too high to keep the group solvent. " +
                          "This is due to the sum of existing session amounts."                          
        format.html { redirect_back_or_default :back }
      end
    end
  end
end
