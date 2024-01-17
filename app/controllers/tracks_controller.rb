class TracksController < ApplicationController
  def search
    if params[:search].present?
      search_results = RSpotify::Track.search(params[:search])
      @tracks = search_results.first(9)

      respond_to do |format|
        format.turbo_stream
        format.json { render json: @tracks.map { |track| { id: track.id, name: track.name } } }
        format.html { render partial: "tracks/search_results", locals: { tracks: @tracks } }
      end
    end
  end
end

