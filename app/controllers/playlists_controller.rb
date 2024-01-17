class PlaylistsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @playlists = Playlist.where(status: :published).order(created_at: :desc).includes(:user)
  end

  def show
    @playlist = Playlist.find(params[:id])
  end

  def new
    session.delete(:current_playlist_id) # セッションから前回のプレイリストIDを削除
    @playlist = current_playlist
  end

  def create
    @playlist = current_playlist
    if @playlist.update(playlist_params.merge(status: :published))
      session.delete(:current_playlist_id)
      redirect_to playlist_path(@playlist)
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def add_track_to_playlist
    @playlist = current_playlist
    logger.debug("current_playlist: #{current_playlist.id}")

    spotify_track = RSpotify::Track.find(params[:track_id])
    @track = Track.find_or_create_by(spotify_id: params[:track_id]) do |t|
      t.title = spotify_track.name
      t.artist = spotify_track.artists.first.name
    end

    @playlist.tracks << @track unless @playlist.tracks.include?(@track)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("playlist_tracks", partial: "playlists/track", locals: { track: @track })
      end
    end
  end

  private

  def playlist_params
    params.require(:playlist).permit(:title, :description)
  end
end
