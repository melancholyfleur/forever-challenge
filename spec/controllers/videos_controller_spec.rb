require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  describe "GET #index" do
    before(:each) do
      album = Album.create(name: Faker::Lorem.word.capitalize)
      20.times do
        album.videos.create(
            name: Faker::Lorem.word.capitalize,
            description: Faker::Lorem.sentence,
            url: Faker::File.file_name(SecureRandom.hex, 'mp4'),
            taken_at: Time.now - rand(100).days
        )
      end
    end

    it "lists a max of 10 videos per page" do
      get :index, page: 1
      expect(JSON.parse(response.body)['videos'].count).to eq 10
    end

    it "shows next page of videos upon request" do
      get :index, page: 2
      expect(response.body).to_not be nil
      expect(JSON.parse(response.body)['videos'].count).to eq 10
    end

    it "shows the total number of videos" do
      get :index, page: 1
      expect(JSON.parse(response.body)['total']).to eq 20
    end
  end

  describe "POST #create" do
    before(:each) do
      @album = Album.create(name: "LOLALBUM")
    end

    context "with valid params" do
      it "creates a new Video" do
        valid_attributes = [{
          name: Faker::Lorem.word.capitalize,
          description: Faker::Lorem.sentence,
          url: Faker::File.file_name(SecureRandom.hex, 'mp4'),
          taken_at: Time.now - rand(100).days,
          album_id: @album.id
        }]
        expect {
          post :create, {:videos => valid_attributes}
        }.to change(Video, :count).by(1)
      end

      it "creates multiple videos if present" do
        valid_multiple_video_params = {
          videos:
          [{
            name: "Kenshin",
            url: "http://example.com/himura.mp4",
            album_id: @album.id,
            taken_at: Time.now - rand(100).days
          },
          {
            name: "Kaoru",
            url: "http://example.com/kaoru.mp4",
            album_id: @album.id,
            taken_at: Time.now - rand(100).days
          },
          {
            name: "Yahiko",
            url: "http://example.com/yahiko.mp4",
            album_id: @album.id,
            taken_at: Time.now - rand(100).days
          },
          {
            name: "Sanosuke",
            url: "http://example.com/sanosuke.mp4",
            album_id: @album.id,
            taken_at: Time.now - rand(100).days
          }]
        }
        expect {
          post :create, valid_multiple_video_params
        }.to change(Video, :count).by(4)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved video as @video" do
        invalid_attributes = {videos: [{name: "", url: "", album_id: @album.id}]}
        post :create, invalid_attributes
        expect(assigns(:video)).to be_a_new(Video)
      end

      it "adds all videos with valid json, but not videos with invalid json" do
        multiple_video_params = {
          videos: 
          [{
            name: "Raj Al Ghoul", 
            url: "http://placekitten.com/raj.mp4", 
            album_id: @album.id 
          },
          {
            name: "Talia Al Ghoul", 
            url: "http://placekitten.com/talia.alghoul", 
            album_id: @album.id 
          },
          {
            name: "Batman", 
            url: "http://placekitten.com/bruce.mp4", 
            album_id: @album.id 
          }]
        }
        post :create, multiple_video_params
        expect(@album.videos.count).to eq 2
        expect(JSON.parse(response.body)['errors']).to_not be_empty
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested video" do
      album = Album.create(name: Faker::Lorem.word.capitalize)
      video = album.videos.create(
        name: Faker::Lorem.word.capitalize,
        description: Faker::Lorem.sentence,
        url: Faker::File.file_name(SecureRandom.hex, 'mp4'),
        taken_at: Time.now - rand(100).days
      )
      expect {
        delete :destroy, {:id => video.id}
      }.to change(Video, :count).by(-1)
    end
  end
end
