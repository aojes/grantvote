class CommunicationsController < ApplicationController
  before_filter :require_user

  def create
    @communication = Communication.new(params[:communication])

    if @communication.save
      flash[:notice] = 'Updated!'
      redirect_to home_path
    else
      flash[:notice] = 'Please try again..'
      redirect_to home_path
    end
  end

  def destroy
    @commmunication = Communication.find(params[:id])
    @commmunication.destroy

    respond_to do |format|
      format.html { redirect_back_or_default :back }
    end
  end
end

