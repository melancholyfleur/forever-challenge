class Album < ActiveRecord::Base
  has_many :photos
  validates :name, presence: true
  paginates_per 10
end
