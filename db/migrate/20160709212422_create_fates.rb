class CreateFates < ActiveRecord::Migration
  def change
    create_table :fates do |t|
      t.references :big_tournament_tour
      t.references :player
      t.integer :tour,  default: 0
      t.integer :table, default: 0
      t.timestamps null: false
    end
  end
end
