class ProfilesController < ApplicationController
  # require user for private production
  before_filter :require_user
  def view
    @user = User.find_by_login(params[:permalink])
    if @user
      @page_title = @user.login + ' on Grantvote'

      # grant & blitz awards    ### TODO sort by updated_at
      @awards = @user.grants.awarded.concat(@user.blitzes.awarded).
                  sort {|a, b| a.updated_at <=> b.updated_at }

      # grant & blitz sessions  ###
      @session = @user.grants.session.concat(@user.blitzes.session).
                   sort {|a,b| b.updated_at <=> a.updated_at }

      # grant & blitz writeboard
      @writeboard = @user.grants.writeboard.concat(@user.blitzes.writeboard)

      respond_to { |format| format.html }
    else
      flash[:notice] = 'The page you were looking for was not found.'
      redirect_to root_path
    end
  end

end

