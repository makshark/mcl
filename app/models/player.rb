class Player < ActiveRecord::Base
  has_many :game_players
  has_many :games
end
