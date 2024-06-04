class PlaylistsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @playlists = Playlist.includes(:user, :mood).order(created_at: :desc).page(params[:page])
  end

  def show
    @playlist = Playlist.includes(:user).find(params[:id])
    @playlist.increment(:clicks_count)
    @playlist.save
  end

  def new
    session.delete(:current_playlist_tracks)
    @playlist = Playlist.new
  end

  def edit
    @playlist = current_user.playlists.find(params[:id])
  end

  def create
    @playlist = current_user.playlists.new(playlist_params)

    if session[:current_playlist_tracks].present?
      tracks = Track.where(id: session[:current_playlist_tracks])
      @playlist.tracks = tracks
    end

    if @playlist.save
      session.delete(:current_playlist_tracks)
      redirect_to playlist_path(@playlist), notice: I18n.t('notices.new_playlist')
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = @playlist.errors.full_messages.join(', ')
          render turbo_stream: turbo_stream.replace('flash_messages', partial: 'shared/flash')
        end
      end
    end
  end

  def update
    @playlist = current_user.playlists.find(params[:id])

    if @playlist.update(playlist_params)
      redirect_to playlist_path(@playlist), notice: I18n.t('notices.playlist_updated')
    else
      flash.now[:alert] = I18n.t('notices.playlist_update_failed')
      render :edit
    end
  end

  def destroy
    @playlist = current_user.playlists.find(params[:id])
    @playlist.destroy
    redirect_to playlists_path, notice: I18n.t('notices.playlist_deleted')
  end

  def add_track_to_playlist
    spotify_track = RSpotify::Track.find(params[:track_id])
    @track = Track.find_or_create_by(spotify_id: params[:track_id]) do |t|
      t.title = spotify_track.name
      t.artist = spotify_track.artists.first.name
    end

    session[:current_playlist_tracks] ||= []
    session[:current_playlist_tracks] << @track.id unless session[:current_playlist_tracks].include?(@track.id)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append('playlist_preview', partial: 'playlists/track_with_remove_button',
                                                                      locals: { track: @track })
      end
    end
  end

  def remove_track_from_playlist
    session[:current_playlist_tracks].delete(params[:track_id].to_i)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("track_#{params[:track_id]}")
      end
    end
  end

  def new_releases
    @playlists = Playlist.includes(:user, :mood).where('created_at >= ?',
    12.hours.ago).order(created_at: :desc).page(params[:page])
  end

  def my_playlists
    @playlists = current_user.playlists.includes(:user, :mood).order(created_at: :desc).page(params[:page])
  end

  def trend_picks
    @playlists = Playlist.includes(:user, :mood).most_popular.page(params[:page]).per(8)
  end

  def todays_picks
    @playlists = Playlist.includes(:user, :mood).todays_picks.page(params[:page]).per(8)
  end

  private

  def playlist_params
    params.require(:playlist).permit(:title, :description, :mood_id)
  end
end
