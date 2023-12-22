class Playlist < ApplicationRecord
  has_many :playlist_trackw
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true
end
