class Album < ActiveRecord::Base
  has_many :photos
  paginates_per 10
end
