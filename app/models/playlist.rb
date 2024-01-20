class Playlist < ApplicationRecord
  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks
  has_many :comments, dependent: :destroy
  has_many :good_vibes, dependent: :destroy
  has_many :good_vibed_users, through: :good_vibes, source: :user
  belongs_to :user

  validates :title, presence: true, length: { maximum: 20 }
  validates :description, presence: true, length: { maximum: 3000 }

  enum status: {
    creating: 0,
    published: 1
  }
end
