class AddPlayersListToTour < ActiveRecord::Migration
  def change
    add_column :big_tournament_tours, :list_of_players, :text
  end
end
