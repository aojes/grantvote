class ProfilesController < ApplicationController
  # require user for private production
  before_filter :require_user
  def view
    @user = User.find_by_login(params[:permalink])
    @page_title = @user.login + ' on Grantvote'
    
    ##
    # group & blitz award count
    # grant & blitz awards
    # grant & blitz sessions
    
    @awards = @user.grants.awarded.concat(@user.blitzes.awarded)
    
    @session = @user.grants.session.reject {|g| g.votes.count.zero? }.
      concat(@user.blitzes.session.reject {|b| b.votes.count.zero? })
    
    # grant & blitz writeboard
    @writeboard = @user.grants.session.reject {|g| !g.votes.count.zero?}.
      concat(@user.blitzes.reject {|b| !b.votes.count.zero?})
    
   
    respond_to do |format|
      if @user
        format.html
      else
        flash[:notice] = 'The page you were looking for was not found.'
        format.html { redirect_to root_path }
      end
    end    
  end

end
