require 'rails_helper'

RSpec.describe Video, type: :model do
  before(:each) do
    @album = Album.create(name: "Album 3001")
  end

  it "requires a name" do
    expect(Video.new(name: "", url: "http://example.com/photo.mp4", album: @album)).to_not be_valid
  end

  it "requires a url" do
    expect(Video.new(name: "Great Photo Name", url: "", album: @album)).to_not be_valid
  end

  it "requires a url end with jpg or jpeg" do
    expect(Video.new(name: "Great Photo Name", url: "http://placekitten.com/40/50", album: @album)).to_not be_valid
  end

  it "requires an album association" do
    expect(Video.new(name: "Great Photo Name", url: "http://example.com/photo.mp4", album: @album)).to be_valid
  end
end
