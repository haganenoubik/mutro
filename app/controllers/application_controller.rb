class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_current_playlist(playlist)
    session[:current_playlist_id] = playlist.id
  end

  private

  def current_playlist
    if session[:current_playlist_id]
      @current_playlist ||= Playlist.find_by(id: session[:current_playlist_id])
    else
      @current_playlist = current_user.playlists.new(status: :creating)
      if @current_playlist.save
        session[:current_playlist_id] = @current_playlist.id
      else
        logger.debug "Failed to create new playlist: #{@current_playlist.errors.full_messages}"
      end
    end

    logger.debug "Session current_playlist_id: #{session[:current_playlist_id]}"
    logger.debug "Current playlist: #{@current_playlist.inspect}"

    @current_playlist
  end

  protected

  def configure_permitted_parameters
    # 新規登録時のストロングパラメータ
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

    # プロフィール編集時のストロングパラメータ
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :bio])
  end
end
