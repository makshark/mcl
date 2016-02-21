class BigTournamentTour < ActiveRecord::Base
  belongs_to :big_tournament
  has_many :games

  validates :big_tournament_id, :list_of_players, presence: true
end
