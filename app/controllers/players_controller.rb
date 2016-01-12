class PlayersController < ApplicationController

  def list_of_players
    render json: Player.pluck(:id, :nick)
  end

  def list_of_leadings
    render json: Player.where(leading: true).pluck(:id, :nick)
  end





end
