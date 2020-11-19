class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @photo = Photo.find(params[:photo_id])
    favorite = Favorite.new(photo_id: @photo.id)
    favorite.user_id = current_user.id
    @photo.update(favorites_quantity: @photo.favorites_quantity + 1)
    favorite.save
  end

  def destroy
    @photo = Photo.find(params[:photo_id])
    favorite = Favorite.find_by(photo_id: @photo.id, user_id: current_user.id)
    @photo.update(favorites_quantity: @photo.favorites_quantity - 1)
    favorite.destroy
  end
end
