class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    @photos = @tag.photos.all
  end
end
