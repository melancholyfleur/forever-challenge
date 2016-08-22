class PhotosController < ApplicationController
  def index
    @photos = Photo.order(:name).page params[:page]
    @total = Photo.count
    render json: {photos: @photos, total: @total}, status: :ok, layout: false
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end
end
