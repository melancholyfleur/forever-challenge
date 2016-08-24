class Album < ActiveRecord::Base
  has_many :photos
  has_many :videos
  validates :name, presence: true
  paginates_per 10
end
