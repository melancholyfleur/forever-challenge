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
      @prev_date = @album.average_date
    end

    it "creates a photo with the correct parameters" do
      valid_params = {photos: [{name: "Super Duper", url: "http://placekitten.com/derp.jpg", album_id: @album.id, taken_at: Time.now - rand(100).days}]}
      post :create, valid_params
      expect(Photo.last.name).to eq "Super Duper"
      expect(JSON.parse(response.body)['photos']).to_not be nil
      expect(JSON.parse(response.body)['errors']).to be_empty
      expect(@album.reload.average_date).not_to eql @prev_date
    end

    it "does not create a photo if not all parameters are present" do
      invalid_params = {photos: [{name: "", url: "", album_id: @album.id}]}
      post :create, invalid_params
      expect(Photo.first).to be nil
      expect(JSON.parse(response.body)['errors']).to_not be_empty
      expect(@album.reload.average_date).to eql @prev_date
    end

    it "adds multiple photos to an album at one time" do
      multiple_photo_params = {
        photos: 
        [{
          name: "Rose", 
          url: "http://placekitten.com/rose.jpg", 
          album_id: @album.id 
        },
        {
          name: "Mr. Universe", 
          url: "http://placekitten.com/greg.jpg", 
          album_id: @album.id 
        },
        {
          name: "Stephen", 
          url: "http://placekitten.com/rosequartz.jpg", 
          album_id: @album.id 
        },
        {
          name: "Amethyst", 
          url: "http://placekitten.com/amethyst.jpg", 
          album_id: @album.id 
        },
        {
          name: "Pearl", 
          url: "http://placekitten.com/pearl.jpg", 
          album_id: @album.id 
        },
        {
          name: "Garnet", 
          url: "http://placekitten.com/garnet.jpg", 
          album_id: @album.id 
        }]
      }
      post :create, multiple_photo_params
      expect(@album.photos.count).to eq 6
      expect(@album.reload.average_date).not_to eql @prev_date
    end

    it "adds all photos with valid json, but not photos with invalid json" do
      multiple_photo_params = {
        photos: 
        [{
          name: "Raj Al Ghoul", 
          url: "http://placekitten.com/raj.jpeg", 
          album_id: @album.id 
        },
        {
          name: "Talia Al Ghoul", 
          url: "http://placekitten.com/talia.alghoul", 
          album_id: @album.id 
        },
        {
          name: "Batman", 
          url: "http://placekitten.com/bruce.jpg", 
          album_id: @album.id 
        }]
      }
      post :create, multiple_photo_params
      expect(@album.photos.count).to eq 2
      expect(JSON.parse(response.body)['errors']).to_not be_empty
    end
  end

  describe "update" do
    before(:each) do
      @album = Album.create(name: Faker::Lorem.word.capitalize)
      @prev_date = @album.average_date
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
      expect(JSON.parse(response.body)['photo']).to_not be nil
      expect(JSON.parse(response.body)['error']).to be nil
      expect(@album.reload.average_date).not_to eql @prev_date
    end

    it "does not update name attribute if parameter is blank" do
      invalid_params = {id: @photo.id, photo:{ name: ""}}
      put :update, invalid_params
      expect(JSON.parse(response.body)['photo']).to be nil
      expect(JSON.parse(response.body)['error']).to_not be nil
      expect(@album.reload.average_date).to eql @prev_date
    end
  end

  describe "destroy" do
    it "removes existing album" do
      album = Album.create(name: Faker::Lorem.word.capitalize)
      prev_date = album.average_date
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
      expect(album.reload.average_date).not_to eql prev_date
    end
  end
end
