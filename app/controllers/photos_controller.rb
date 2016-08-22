class PhotosController < ApplicationController
  def index
    @photos = Photo.order(:name).page params[:page]
    @total = Photo.count
    render json: {photos: @photos, total: @total}, status: :ok, layout: false
  end

  def show
    @photo = Photo.find(params[:id])
    unless @photo
      render json: {}, status: :not_found, layout: false
    else
      render json: {photo: @photo}, status: :ok, layout: false
    end
  end

  def create
    @photo = Photo.new(photo_params)
    if @photo.valid?
      @photo.save
      render json: {photo: @photo}, status: :ok, layout: false
    else
      render json: {photo: nil, error: @photo.errors.messages}, status: :ok, layout: false
    end
  end

  def update
    @photo = Photo.update(params[:id], photo_params)
    if @photo.valid?
      @photo.save
      render json: {photo: @photo}, status: :ok, layout: false
    else
      render json: {photo: nil, error: @photo.errors.messages}, status: :ok, layout: false
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    if @photo
      @photo.destroy
      render json: {photo: @photo}, status: :ok, layout: false
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:album_id, :name, :url, :description, :taken_at)
  end
end
