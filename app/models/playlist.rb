class Playlist < ApplicationRecord
  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks
  belongs_to :user

  validates :title, length: { maximum: 20 }
  validates :description, presence: true, length: { minimum: 30, maximum: 1000 }

  enum status: {
    creating: 0,
    published: 1  
  } 
end
