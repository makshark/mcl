class CreateMiniTournaments < ActiveRecord::Migration
  def change
    create_table :mini_tournaments do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
