class BigTournamentTour < ActiveRecord::Base
  belongs_to :big_tournament
  has_many :games
  has_many :tournament_players_teams
  has_many :fates
  validates :big_tournament_id, :list_of_players, presence: true
end
