class Video < ActiveRecord::Base
  belongs_to :album
  validates :album, presence: true
  validates :name, presence: true
  validates :url, presence: true
  validates_format_of :url, with: /.*mp4/i
  paginates_per 10
end
