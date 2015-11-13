class AddLeadingToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :leading, :boolean, default: false
  end
end
