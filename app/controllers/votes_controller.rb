class VotesController < ApplicationController
  before_filter :require_user
  before_filter :verify_authenticity_token
  
  def create
    @vote = Vote.new(params[:vote])

    respond_to do |format|
      if @vote.blitz
        if @vote.save
          flash[:notice] = @vote.blitz.final_message || 'Voted successfully.'
          format.html { redirect_to blitz_path(@vote.blitz) }
        else
          flash[:notice] = @vote.blitz.limit_message || 
                                      'Bleep, bloop. Please try again.'
          format.html { redirect_to blitz_path(@vote.blitz) }
        end

      elsif @vote.group and @vote.group.solvent?
        if @vote.save
          flash[:notice] = @vote.final_message || 'Voted successfully.'
          format.html { redirect_to group_grant_path(@vote.group, @vote.grant) }
        else
          flash[:notice] = @vote.limit_message ||
                                        'Bleep, bloop. Please try again.'
          format.html { redirect_to group_grant_path(@vote.group, @vote.grant) }
        end

      elsif @vote.group
        flash[:notice] = 'Amount is too high to keep the group solvent. ' +
                          'This is due to the sum of existing session amounts.'
        format.html { redirect_back_or_default :back }
      end
    end
  end
  
end
