class CreatePointsSettings < ActiveRecord::Migration
  def change
    create_table :points_settings do |t|

      t.timestamps null: false
    end
  end
end
