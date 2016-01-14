class PlayersController < ApplicationController

  def list_of_players
    render json: Player.pluck(:id, :nick)
  end

  def list_of_leadings
    render json: Player.where(leading: true).pluck(:id, :nick)
  end

  def players_rating
    @result_array = []
    object = {}
    #TODO: очень быдловское решение, если не исправлю - будет стыдно
   players_points_count = GamePlayer.group(:player_id)
                               .sum(:points)
   players_points_count.each do |player|
     game_count = GamePlayer.where(player_id: player[0]).count
     nick = Player.where(id: player[0]).first
     rating = player[1] / game_count.to_f * 100
     object[:game_count] = game_count
     object[:nick] = nick.try(:nick)
     object[:rating] = rating
     @result_array << object
     object = {}
   end
    @result_array = @result_array.sort_by { |hsh| hsh[:rating] }.reverse!
   # @players_game_count = GamePlayer.group(:player_id).count(:game_id)
  end



end
