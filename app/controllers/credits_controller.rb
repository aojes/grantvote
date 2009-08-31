class CreditsController < ApplicationController
  before_filter :require_user
  before_filter :verify_authenticity_token

  def create
    @credit = Credit.new(params[:credit])

  end

  def update
    @receiver = Credit.new(params[:credit])
    if (   params[:credit][:pebbles]                                          &&
           current_user.credit.update_attributes(
             :buttons => (current_user.credit.buttons   + 1) )                &&
           current_user.update_attributes(:points => current_user.points - 1) &&
           @receiver.user.credit.update_attributes(
             :pearls  => (@receiver.user.credit.pearls  + 1),
             :buttons => (@receiver.user.credit.buttons - 1) )
        ) ||

        (
           current_user.credit.update_attributes(
             :beads   => (current_user.credit.beads   - 1),
             :shells  => (current_user.credit.shells  + 1) )                  &&
           current_user.update_attributes(:points => current_user.points + 1) &&
           @receiver.user.credit.update_attributes(
             :beads   => (@receiver.user.credit.beads + 1) )
        )

      flash[:notice] = 'Success! Helping your fellow Grantvoter.'
      redirect_back_or_default :back
    else
      flash[:notice] = 'Bleep, bloop.  Please try again.'
      redirect_back_or_default :back
    end
  end
end

