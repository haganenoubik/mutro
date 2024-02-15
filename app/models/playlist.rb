class Playlist < ApplicationRecord
  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks
  has_many :comments, dependent: :destroy
  has_many :good_vibes, dependent: :destroy
  has_many :good_vibed_users, through: :good_vibes, source: :user
  belongs_to :user

  validates :title, presence: true, length: { maximum: 20 }
  validates :description, presence: true, length: { maximum: 10_000 }
  validate :tracks_count_within_limit

  enum status: {
    creating: 0,
    published: 1
  }

  def self.most_popular(limit = 8)
    order(clicks_count: :desc).limit(limit)
  end

  def self.todays_picks(limit = 8)
    seed = Date.today.to_s.hash
    ids = Playlist.pluck(:id).shuffle(random: Random.new(seed))
    Playlist.where(id: ids.take(limit))
  end

  private

  def tracks_count_within_limit
    return unless tracks.size < 5 || tracks.size > 20

    errors.add(:tracks, :tracks_count_within_limit)
  end
end
