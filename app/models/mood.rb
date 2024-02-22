class Mood < ApplicationRecord
  has_many :playlists, dependent: :destroy
end
