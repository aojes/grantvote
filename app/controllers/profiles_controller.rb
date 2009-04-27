class ProfilesController < ApplicationController

  def view
    @profile = Profile.find_by_permalink(params[:permalink])
   
    respond_to do |format|
      if @profile
        format.html
      else
        flash[:notice] = "The page you were looking for was not found."
        format.html { redirect_to root_path }
      end
    end    
  end

end
