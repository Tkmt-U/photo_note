class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @photos = Photo.where(user_id: params[:id])
    @user = User.find(params[:id])
  end

  def mypage
    @user = current_user
  end

  def edit
  end
end
