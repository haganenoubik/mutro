class CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @playlist = Playlist.find(params[:playlist_id])
    @comment = @playlist.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @playlist, notice: 'コメントが追加されました'
    else
      redirect_to @playlist, alert: 'コメントの追加に失敗しました'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
