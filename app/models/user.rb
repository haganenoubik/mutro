class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :playlists, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :good_vibes, dependent: :destroy
end
