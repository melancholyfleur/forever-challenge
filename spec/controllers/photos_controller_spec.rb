require 'rails_helper'

RSpec.describe PhotosController, type: :controller do
  describe "index" do
    before(:each) do
      album = Album.create(name: Faker::Lorem.word.capitalize)
      20.times do |index|
        album.photos.create(
          name: Faker::Lorem.word.capitalize,
          description: Faker::Lorem.sentence,
          url: Faker::Avatar.image(SecureRandom.hex, '50x50', 'jpg'),
          taken_at: Time.now - rand(100).days
        )
      end
    end

    it "lists a max of 10 albums per page" do
      get :index, page: 1
      expect(JSON.parse(response.body)['photos'].count).to eq 10
    end

    it "shows next page of albums upon request" do
      get :index, page: 2
      expect(response.body).to_not be nil
      expect(JSON.parse(response.body)['photos'].count).to eq 10
    end

    it "shows the total number of albums" do
      get :index, page: 2
      expect(JSON.parse(response.body)['total']).to eq 20
    end
  end

  describe "create" do
    before(:each) do
      @album = Album.create(name: "LOLALBUM")
    end

    it "creates a photo with the correct parameters" do
      valid_params = {photo: {name: "Super Duper", url: "http://placekitten.com/derp.jpg", album_id: @album.id}}
      post :create, valid_params
      expect(Photo.first.name).to eq "Super Duper"
    end

    it "does not create a photo if not all parameters are present" do
      invalid_params = {photo: {name: "", url: "", album_id: @album.id}}
      post :create, invalid_params
      expect(Photo.first).to be nil
      expect(response.body).to include "error"
    end
  end

  describe "update" do
    before(:each) do
      @album = Album.create(name: Faker::Lorem.word.capitalize)
      @photo = @album.photos.create(
        name: Faker::Lorem.word.capitalize, 
        url: Faker::Avatar.image(SecureRandom.hex, '50x50', 'jpg'),
        taken_at: Time.now - rand(100).days
      )
    end

    it "updates name attribute" do
      valid_params = {id: @photo.id, photo: { name: "The Dude Abides"}}
      post :update, valid_params
      expect(Photo.first.name).to eq "The Dude Abides"
    end

    it "does not update name attribute if parameter is blank" do
      invalid_params = {id: @photo.id, photo:{ name: ""}}
      put :update, invalid_params
      expect(response.body).to include "error"
    end
  end

  describe "destroy" do
    it "removes existing album" do
      album = Album.create(name: Faker::Lorem.word.capitalize)
      photo = album.photos.create(
        name: Faker::Lorem.word.capitalize,
        description: Faker::Lorem.sentence,
        url: Faker::Avatar.image(SecureRandom.hex, '50x50', 'jpg'),
        taken_at: Time.now - rand(100).days
      )
      photo2 = album.photos.create(
        name: Faker::Lorem.word.capitalize,
        description: Faker::Lorem.sentence,
        url: Faker::Avatar.image(SecureRandom.hex, '50x50', 'jpg'),
        taken_at: Time.now - rand(100).days
      )
      photo_count = Photo.count
      delete :destroy, id: photo.id
      expect(response.status).to eq 200
      expect(Photo.count).to eq photo_count-1
    end
  end
end
