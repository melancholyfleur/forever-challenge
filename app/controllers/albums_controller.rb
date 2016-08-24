class AlbumsController < ApplicationController
  def index
    @albums = Album.order(:name).page params[:page]
    @total = Album.count
    render json: {albums: @albums, total: @total}, status: :ok, layout: false
  end

  def show
    @album = Album.find(params[:id])
    unless @album
      render json: {}, status: :not_found, layout: false
    else
      @photos = @album.photos
      @videos = @album.videos
      render json: {album: @album, photos: @photos, videos: @videos}, status: :ok, layout: false
    end
  end

  def create
    @album = Album.new(album_params)
    if @album.valid?
      @album.save
      render json: {album: @album}, status: :ok, layout: false
    else
      render json: {album: nil, error: @album.errors.messages}, status: :ok, layout: false
    end
  end

  def update
    @album = Album.update(params[:id], album_params)
    if @album.valid?
      @album.save
      render json: {album: @album}, status: :ok, layout: false
    else
      render json: {album: nil, error: @album.errors.messages}, status: :ok, layout: false
    end
  end

  def destroy
    @album = Album.find(params[:id])
    if @album
      @album.destroy
      render json: {album: @album}, status: :ok, layout: false
    end
  end

  private

  def album_params
    params.require(:album).permit(:name)
  end
end
