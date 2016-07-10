class AddTourAmountAndTableAmountToBigTournamentTour < ActiveRecord::Migration
  def change
    add_column :big_tournament_tours, :tour_amount,  :integer, default: 0
    add_column :big_tournament_tours, :table_amount, :integer, default: 0
  end
end
