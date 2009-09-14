class CreditsController < ApplicationController
  before_filter :require_user

  def update
    receiver = User.find(params[:credit][:user_id].to_i)
    give = params[:credit][:give_bead] == '1' ? :bead : :pearl
    
    if receiver && Credit.give!(current_user, receiver, give, Time.now)
      flash[:notice] = 'Success! Helping your fellow Grantvoter.'
      redirect_back_or_default :back
    else
      flash[:notice] = 'Bleep, bloop.  Please try again.'
      redirect_back_or_default :back
    end
  end
end

