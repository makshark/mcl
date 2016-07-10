class BigTournament < ActiveRecord::Base
  has_many :big_tournament_tours
  # Describe tournament mode (single, double and etc)
  enum mode: { single: 0, double: 1 }
end
