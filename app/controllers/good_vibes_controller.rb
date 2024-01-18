class GoodVibesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_playlist

  def create
    @playlist.good_vibes.create!(user: current_user) unless current_user.good_vibed?(@playlist)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @playlist }
    end
  end

  def destroy
    good_vibe = @playlist.good_vibes.find_by(user_id: current_user.id)
    good_vibe&.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @playlist }
    end
  end

  private

  def set_playlist
    @playlist = Playlist.find(params[:playlist_id])
  end
end
