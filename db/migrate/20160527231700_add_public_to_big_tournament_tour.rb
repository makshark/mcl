class AddPublicToBigTournamentTour < ActiveRecord::Migration
  def change
    add_column :big_tournament_tours, :public, :boolean, default: false
  end
end
