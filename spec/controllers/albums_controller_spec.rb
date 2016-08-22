require 'rails_helper'

RSpec.describe AlbumsController, type: :controller do
  describe "index" do
    before(:each) do
      20.times do
        Album.create(name: Faker::Lorem.word.capitalize)
      end
    end

    it "lists a max of 10 albums per page" do
      get :index, page: 1
      expect(JSON.parse(response.body)['albums'].count).to eq 10
    end

    it "shows next page of albums upon request" do
      get :index, page: 2
      expect(response.body).to_not be nil
      expect(JSON.parse(response.body)['albums'].count).to eq 10
    end

    it "shows the total number of albums" do
      get :index, page: 2
      expect(JSON.parse(response.body)['total']).to eq 20
    end
  end

  describe "show" do
    before(:each) do
      album = Album.create(name: Faker::Lorem.word.capitalize)
      2.times do |photo_index|
        album.photos.create(
          name: Faker::Lorem.word.capitalize,
          description: Faker::Lorem.sentence,
          url: Faker::Avatar.image(SecureRandom.hex, '50x50', 'jpg'),
          taken_at: Time.now - rand(100).days
        )
      end
    end

    it "shows all photo data for the album" do
      get :show, id: Album.first.id
      photos_json = JSON.parse(response.body)['photos']
      expect(photos_json.count).to eq 2
    end
  end

  describe "create" do
    it "creates an album with the correct parameters" do
      valid_params = {album: {name: "The Dude Abides"}}
      post :create, valid_params
      expect(Album.first.name).to eq "The Dude Abides"
    end

    it "does not create an album if not all parameters are provided" do
      invalid_params = {album: {name: ""}}
      post :create, invalid_params
      expect(Album.first).to be nil
      expect(response.body).to include "error"
    end
  end

  describe "update" do
    before(:each) do
      @album = Album.create(name: Faker::Lorem.word.capitalize)
    end

    it "updates name attribute" do
      valid_params = {id: @album.id, album: { name: "The Dude Abides"}}
      post :update, valid_params
      expect(Album.first.name).to eq "The Dude Abides"
    end

    it "does not update name attribute if parameter is blank" do
      invalid_params = {id: @album.id, album:{ name: ""}}
      put :update, invalid_params
      expect(response.body).to include "error"
    end
  end

  describe "destroy" do
    it "removes existing album" do
      album = Album.create(name: Faker::Lorem.word.capitalize)
      album2 = Album.create(name: Faker::Lorem.word.capitalize)
      album_count = Album.count
      delete :destroy, id: album.id
      expect(response.status).to eq 200
      expect(Album.count).to eq album_count-1
    end
  end
end
