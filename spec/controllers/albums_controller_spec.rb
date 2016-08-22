require 'rails_helper'

RSpec.describe AlbumsController, type: :controller do
  describe "index" do
    before(:each) do
      20.times do |index|
        Album.create(name: Faker::Lorem.word.capitalize, position: index)
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
      get :index, page: 3
      expect(JSON.parse(response.body)['total']).to eq 20
    end
  end

  describe "show" do
    before(:each) do
      album = Album.create(name: Faker::Lorem.word.capitalize, position: 1)
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
      album_name = Album.first.name
      get :show, name: album_name
      photos_json = JSON.parse(response.body)['photos']
      expect(photos_json.count).to eq 2
    end
  end
end
