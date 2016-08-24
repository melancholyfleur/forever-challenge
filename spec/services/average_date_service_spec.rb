require 'rails_helper'

describe AverageDateService do
  describe "calculate_average_date" do
    before(:each) do
      @album = Album.create(name: Faker::Lorem.word.capitalize)
      20.times do |index|
        @album.photos.create(
          name: Faker::Lorem.word.capitalize,
          description: Faker::Lorem.sentence,
          url: Faker::Avatar.image(SecureRandom.hex, '50x50', 'jpg'),
          taken_at: Time.now - rand(100).days
        )
      end
      average_date = 0.0
      @album.photos.each do |m|
        average_date = average_date + m.taken_at.to_f if m.taken_at
      end
      average_date = average_date / @album.photos.size
      @average_date = Time.at(average_date).to_date
    end

    it "sets album's average date to nil if there are no photos" do
      album = Album.create(name: Faker::Lorem.word.capitalize)
      options = {album: album, media: album.photos}
      ads_no_photos = AverageDateService.new(options)
      ads_no_photos.calculate_average_date
      expect(album.average_date).to be nil
    end

    it "sets album's average date if there are photos" do
      options = {album: @album, media: @album.photos}
      ads_photos = AverageDateService.new(options)
      ads_photos.calculate_average_date
      expect(@album.average_date).to eq @average_date
    end
  end
end
