class AddPlaceFieldToFate < ActiveRecord::Migration
  def change
    add_column :fates, :place, :integer, default: 0
  end
end
