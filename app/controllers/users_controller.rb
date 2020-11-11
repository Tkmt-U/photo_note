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
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = "Update successful"
      redirect_to users_mypage_path
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :email, :profile_image)
  end
end
