class Playlist < ApplicationRecord
  has_many :playlist_tracks
  has_many :tracks, through: :playlist_tracks
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true

  enum status: {
    creating: 0,
    published: 1  
  } 
end
