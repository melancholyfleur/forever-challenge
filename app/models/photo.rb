class Photo < ActiveRecord::Base
  belongs_to :album
  validates :album, presence: true
  validate :photo_limit, :on => :create
  validates :name, presence: true
  validates :url, presence: true
  validates_format_of :url, with: /.*jpe*g/i
  paginates_per 10

  def self.photo_limit
    60
  end

  def photo_limit
    if self.album.photos(:reload).count >= Photo.photo_limit
      errors.add(:base, "You have exceeded the maximum allowed photos for this album")
    end
  end
end
