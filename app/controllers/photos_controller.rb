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
    photos = []
    errors = []
    create_params.each do |photo_param|
      @photo = Photo.new(photo_param)
      album = Album.find(photo_param[:album_id])
      if @photo.valid?
        @photo.save!
        ads = AverageDateService.new({album: album, media: album.photos})
        album = ads.calculate_average_date
        photos << @photo
      else
        errors << @photo.errors.messages
      end
    end
    photos_json = {photos: photos, errors: errors}
    render json: photos_json, status: :ok, layout: false
  end

  def update
    @photo = Photo.update(params[:id], update_params)
    if @photo.valid?
      @photo.save
      ads = AverageDateService.new({album: @photo.album, media: @photo.album.photos})
      ads.calculate_average_date
      render json: {photo: @photo}, status: :ok, layout: false
    else
      render json: {photo: nil, error: @photo.errors.messages}, status: :ok, layout: false
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    if @photo
      @photo.destroy
      ads = AverageDateService.new({album: @photo.album, media: @photo.album.photos})
      ads.calculate_average_date
      render json: {photo: @photo}, status: :ok, layout: false
    end
  end

  private

  def update_params
    params.require(:photo).permit(:name, :url, :album_id, :description, :taken_at)
  end

  def create_params
    params.permit(photos: [:name, :url, :album_id, :description, :taken_at]).require(:photos)
  end
end
