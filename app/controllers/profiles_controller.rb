class ProfilesController < ApplicationController

  def view
    @user = User.find_by_login(params[:permalink])
   
    respond_to do |format|
      if @user
        format.html
      else
        flash[:notice] = "The page you were looking for was not found."
        format.html { redirect_to root_path }
      end
    end    
  end

end
