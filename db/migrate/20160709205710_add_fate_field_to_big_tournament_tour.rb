class AddFateFieldToBigTournamentTour < ActiveRecord::Migration
  def change
    add_column :big_tournament_tours, :fate, :boolean, default: false
  end
end
