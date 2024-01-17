class PlaylistTracksController < ApplicationController
  before_action :set_playlist
  before_action :set_track, only: %i[destroy]

  def destroy
    @playlist.tracks.delete(@track)
    redirect_to edit_playlist_path(@playlist), notice: '曲が削除されました。'
  end

  private

  def set_playlist
    @playlist = current_user.playlists.find(params[:playlist_id])
  end

  def set_track
    @track = Track.find(params[:id])
  end
end
