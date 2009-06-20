class CreditsController < ApplicationController
  before_filter :require_user
  before_filter :verify_authenticity_token
  
  def create
    @credit = Credit.new(params[:credit])
    
  end
  
  def update
    @receives = Credit.new(params[:credit])
    # defer model method for more complex scenarios
    if current_user.credit.update_attributes(
                               :beads   => (current_user.credit.beads - 1),
                               :shells  => (current_user.credit.shells + 1) ) &&
       @receives.user.credit.update_attributes(                         
                               :beads   => (@receives.user.credit.beads + 1) )
                                          
      flash[:notice] = 'Success! Helping your fellow Grantvoter.'
      redirect_back_or_default :back
    else
      flash[:notice] = 'Bleep, bloop.  Please try again.'
      redirect_back_or_default :back
    end
  end  
end
