class PlaylistsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @playlists = Playlist.order(created_at: :desc).includes(:user).page(params[:page])
  end

  def show
    @playlist = Playlist.find(params[:id])
  end

  def new
    @playlist = Playlist.new
  end

  def edit
    @playlist = current_user.playlists.find(params[:id])
  end

  def create
    @playlist = current_user.playlists.new(playlist_params)

    if session[:current_playlist_tracks].present?
      session[:current_playlist_tracks].each do |track_id|
        track = Track.find(track_id)
        @playlist.tracks << track unless @playlist.tracks.include?(track)
      end
    end

    if @playlist.save
      session.delete(:current_playlist_tracks)
      session.delete(:current_playlist_id)
      redirect_to playlist_path(@playlist), notice: 'プレイリストが作成されました'
    else
      flash.now[:alert] = @playlist.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @playlist = current_user.playlists.find(params[:id])

    if @playlist.update(playlist_params)
      redirect_to playlist_path(@playlist), notice: 'プレイリストが更新されました'
    else
      flash.now[:alert] = 'プレイリストの更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @playlist = current_user.playlists.find(params[:id])
    @playlist.destroy
    redirect_to playlists_path, notice: 'プレイリストが削除されました'
  end

  def add_track_to_playlist
    # 現在のプレイリストIDをセッションに保存（新規作成時のみ）
    session[:current_playlist_id] ||= current_user.playlists.create.id

    spotify_track = RSpotify::Track.find(params[:track_id])
    @track = Track.find_or_create_by(spotify_id: params[:track_id]) do |t|
      t.title = spotify_track.name
      t.artist = spotify_track.artists.first.name
    end

    # 追加された曲のIDをセッションに保存
    session[:current_playlist_tracks] ||= []
    session[:current_playlist_tracks] << @track.id unless session[:current_playlist_tracks].include?(@track.id)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append('playlist_tracks', partial: 'playlists/track', locals: { track: @track })
      end
    end
  end


  def my_playlists
    @playlists = Playlist.where(user: current_user).order(created_at: :desc).page(params[:page]).page(params[:page])
  end

  private

  def playlist_params
    params.require(:playlist).permit(:title, :description)
  end
end
