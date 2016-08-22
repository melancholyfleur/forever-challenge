require 'rails_helper'

RSpec.describe PhotosController, type: :controller do
  describe "index" do
    before(:each) do
      album = Album.create(name: Faker::Lorem.word.capitalize, position: 1)
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
end
