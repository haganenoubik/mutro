class PlaylistsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @playlists = Playlist.where(status: :published).order(created_at: :desc).includes(:user)
  end

  def show
    @playlist = Playlist.find(params[:id])
  end

  def new
    @playlist = current_user.playlists.find_by(status: :creating) || current_user.playlists.new
  end

  def create
    # セッションからプレイリストIDを取得
    @playlist = current_user.playlists.find_by(id: session[:playlist_id])

    # プレイリストが見つからない場合の処理
    unless @playlist
      @playlist = current_user.playlists.new(playlist_params)
      @playlist.status = :creating
    end

    # プレイリストを更新
    if @playlist.update(playlist_params.merge(status: :published))
      session.delete(:playlist_id) # セッションからIDを削除
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
    @playlist = current_user.playlists.find_by(status: :creating) || current_user.playlists.create(status: :creating)
    session[:playlist_id] = @playlist.id

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
