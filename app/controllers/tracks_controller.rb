class TracksController < ApplicationController

  def search
      if params[:search].present?
        @tracks = RSpotify::Track.search(params[:search])
      end
    end
  end
