class CreateBigTournamentTours < ActiveRecord::Migration
  def change
    create_table :big_tournament_tours do |t|
      t. string :name, default: '' # TODO: тоже самое удалить, если это тут не нужно
      t.references :big_tournament
      t.timestamps null: false
    end
  end
end
