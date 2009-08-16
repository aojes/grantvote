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
  
end
