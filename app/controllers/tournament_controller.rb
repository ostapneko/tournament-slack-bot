class TournamentController < ApplicationController
  def handle
    case params['text']
    when 'help'
      render json: { text: 'Shows this' }
    end
  end
end
