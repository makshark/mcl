class AddModeFieldToBigTournament < ActiveRecord::Migration
  def change
    add_column :big_tournaments, :mode, :integer, default: 0
  end
end
