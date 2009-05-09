class CreditsController < ApplicationController
  before_filter :require_user
  before_filter :verify_authenticity_token
  
  def create
    @credit = Credit.new(params[:credit])
    
  end
end
