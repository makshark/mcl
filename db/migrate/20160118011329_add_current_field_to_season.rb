class AddCurrentFieldToSeason < ActiveRecord::Migration
  def change
    add_column :seasons, :current, :boolean, default: false
  end
end
