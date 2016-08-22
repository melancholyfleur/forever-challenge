class AlbumsController < ApplicationController
  def index
    @albums = Album.order(:name).page params[:page]
    @total = Album.count
    render json: {albums: @albums, total: @total}, status: :ok, layout: false
  end

  def show
    @album = Album.find_by_name(params[:name])
    unless @album
      render json: {}, status: :not_found, layout: false
    else
      @photos = @album.photos
      render json: {album: @album, photos: @photos}, status: :ok, layout: false
    end
  end

  def create
  end

  def update
  end

  def destroy
  end
end
