class DashboardController < ApplicationController
  before_action :authenticate_user!

  #simple for now, only show the username and bins counts 
  def index
    @user = current_user
    if @user.nil?
      redirect_to new_user_session_path, alert: "You must be logged in to access the dashboard."
    end
    #@bins_counts = @user.bins.count 
  end
end
