class PhotosController < ApplicationController
  before_action :authenticate_user!, except: [:index, :sort]

  def index
    @photos = Photo.all
  end

  def sort
   selection = params[:selection]
   @photos = Photo.sort(selection)
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.user_id = current_user.id
    @photo.favorites_quantity = 0
    if @photo.save
      flash[:notice] = "Create successful"
      redirect_to photo_path(@photo.id)
    else
      render :new
    end
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  def update
    @photo = Photo.find(params[:id])
    if @photo.update(photo_params)
      flash[:notice] = "Update successful"
      redirect_to photo_path(@photo.id)
    else
      render :edit
    end
  end

  def destroy
    photo = Photo.find(params[:id])
    photo.destroy
    redirect_to "/"
  end

  private
  def photo_params
    params.require(:photo).permit(:user_id, :image, :title, :camera, :lens, :shutter_speed, :f_value, :iso, :item, :comment, :favorites_quantity)
  end
end
