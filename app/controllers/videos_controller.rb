class VideosController < ApplicationController
  before_action :set_video, only: [:show, :destroy]

  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.order(:name).page params[:page]
    @total = Video.count
    render json: {videos: @videos, total: @total}, status: :ok, layout: false
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    unless @video
      render json: {}, stauts: :not_found, layout: false
    else
      render json: {video: @video}, status: :ok, layout: false
    end
  end

  # POST /videos
  # POST /videos.json
  def create
    videos = []
    errors = []
    create_params.each do |video_param|
      @video = Video.new(video_param)
      album = Album.find(video_param[:album_id])
      if @video.valid?
        @video.save!
        videos << @video
      else
        errors << @video.errors.messages
      end
    end
    videos_json = {videos: videos, errors: errors}
    render json: videos_json, status: :ok, layout: false
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    render json: {video: @video}, status: :ok, layout: false
  end

  private
  def set_video
    @video = Video.find(params[:id])
  end

  def create_params
    params.permit(videos: [:name, :url, :album_id, :description, :taken_at]).require(:videos)
  end
end
