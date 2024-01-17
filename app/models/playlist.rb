class Playlist < ApplicationRecord
  before_validation :set_default_values, on: :create

  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks
  has_many :comments, dependent: :destroy
  has_many :good_vibes, dependent: :destroy
  has_many :good_vibed_users, through: :good_vibes, source: :user
  belongs_to :user

  validates :title, length: { maximum: 20 }
  validates :description, length: { maximum: 1000 }

  enum status: {
    creating: 0,
    published: 1  
  } 

  private

  def set_default_values
    self.title ||= ""
    self.description ||= ""
  end
end
