class Player < ActiveRecord::Base
  has_many :game_players
  has_many :games
  has_many :best_game_moves
  has_many :tournament_players_teams
  has_many :fates
end
