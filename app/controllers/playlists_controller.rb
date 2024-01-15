class PlaylistsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def show
  end

  def new
    @playlist = current_user.playlists.find_or_initialize_by(status: "creating")
  end

  def create
    @playlist = current_user.playlists.new(playlist_params) 
    @playlist.status = :creating 
    if @playlist.save
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
    @playlist = current_user.playlists.find_or_create_by(status: :creating)
    spotify_track = RSpotify::Track.find(params[:track_id])

    @track = Track.find_or_create_by(spotify_id: params[:track_id]) do |t|
      t.title = spotify_track.name
      t.artist = spotify_track.artists.first.name
    end

    @playlist.tracks << @track
    @playlist.tracks.reload

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("playlist_tracks", partial: "playlists/track", locals: { track: @track })
      end
    end
  end

  private

  def playlist_params
    params.require(:playlist).permit(:title, :description, track_ids: [])
  end

end
