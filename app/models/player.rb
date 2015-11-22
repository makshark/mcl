class Player < ActiveRecord::Base
  has_many :game_players
  has_many :games
  has_many :best_game_moves
end
