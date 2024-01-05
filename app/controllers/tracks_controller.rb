class TracksController < ApplicationController

  def search
    if params[:search].present?
      @tracks = RSpotify::Track.search(params[:search])
      respond_to do |format|
        format.turbo_stream
        format.html { render partial: "tracks/search_results", locals: { tracks: @tracks } }
      end
    end
  end
end

