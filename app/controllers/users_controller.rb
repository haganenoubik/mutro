class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[show]

  def show
    @user = current_user
    redirect_to root_path unless current_user == @user
  end

  def good_vibes
    @user = User.find(params[:id])
    @good_vibed_playlists = @user.good_vibed_playlists.order(created_at: :desc)

    respond_to do |format|
      format.html
    end
  end
end
