class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @photos = Photo.where(user_id: params[:id])
    @user = User.find(params[:id])
  end

  def mypage
    @user = current_user
    # 以下お気に入りされた数の算出
    photos = Photo.where(user_id: current_user.id) # そのユーザの投稿を全て検索
    @favorite_sum = 0
    photos.each do |photo|
      favorite_count = photo.favorites.count # その投稿一つ一つにお気に入りがどれだけついているか出す
      @favorite_sum += favorite_count # 投稿一つ一つのお気に入りを合計する
    end
    # お気に入りされた数の算出ここまで
  end

  def edit
    @user = current_user
    redirect_to users_mypage_path unless params[:id].to_i == current_user.id
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = "Update successful"
      redirect_to users_mypage_path
    else
      render action: "edit"
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :email, :profile_image)
  end
end
