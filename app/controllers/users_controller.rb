class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[show]

  def show
    @user = current_user
    redirect_to root_path unless current_user == @user
  end
end
