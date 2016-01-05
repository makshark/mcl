class PlayersController < ApplicationController

  def list_of_players
    render json: Player.pluck(:nick)
  end

  def list_of_leadings
    render json: Player.where(leading: true).pluck(:nick)
  end

end
