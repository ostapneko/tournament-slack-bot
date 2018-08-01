class TournamentController < ApplicationController
  def handle
    render json: params["foo"]
  end
end
