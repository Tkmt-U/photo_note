class PhotosController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.user_id = current_user.id
    # binding.pry
    if @photo.save
      redirect_to photo_path(@photo.id)
    else
      render :new
    end
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def edit
  end

  private
  def photo_params
    params.require(:photo).permit(:user_id, :image, :title, :camera, :lens, :shutter_speed, :f_value, :iso, :item, :comment)
  end
end

