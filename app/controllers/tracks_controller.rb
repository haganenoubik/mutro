class TracksController < ApplicationController
  def search
    if params[:search].present?
      search_results = RSpotify::Track.search(params[:search])
      @tracks = search_results.first(9).map do |track|
        {
          id: track.id,
          name: track.name,
          artist: track.artists.first.name
        }
      end
    else
      @tracks = []  # 検索クエリがない場合は空の結果を返す
    end

    respond_to do |format|
      format.turbo_stream
      format.json { render json: @tracks.map { |track| { id: track[:id], name: track[:name], artist: track[:artist] } } }
      format.html { render partial: 'tracks/search_results', locals: { tracks: @tracks } }
    end
  end
end
