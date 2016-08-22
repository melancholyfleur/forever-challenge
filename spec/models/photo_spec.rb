require 'rails_helper'

RSpec.describe Photo, type: :model do
  before(:each) do
    @album = Album.create(name: "Album 3001")
  end

  it "requires a name" do
    expect(Photo.new(name: "", url: "http://example.com/photo.jpg", album: @album)).to_not be_valid
  end

  it "requires a url" do
    expect(Photo.new(name: "Great Photo Name", url: "", album: @album)).to_not be_valid
  end

  it "requires a url end with jpg or jpeg" do
    expect(Photo.new(name: "Great Photo Name", url: "http://placekitten.com/40/50", album: @album)).to_not be_valid
  end

  it "requires an album association" do
    pending "Not sure how to test this now that another validation basically depends on this one; Maybe raise a validation error in that method?"
    expect(Photo.new(name: "Great Photo Name", url: "http://example.com/photo.jpg")).to_not be_valid
  end

  it "limits the amount of photos associated with an album" do
    60.times do
      @album.photos.create(
        name: Faker::Lorem.word.capitalize,
        description: Faker::Lorem.sentence,
        url: Faker::Avatar.image(SecureRandom.hex, '50x50', 'jpg'),
        taken_at: Time.now - rand(100).days
      )
    end
    expect(@album.photos.create(name: 'Sad Photo', 
                        description: "This photo won't be added",
                        url: "http://www.example.com/sad_photo.jpg",
                        taken_at: Time.now - rand(100).days
                       )).to_not be_valid
  end
end
