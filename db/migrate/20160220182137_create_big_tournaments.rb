class CreateBigTournaments < ActiveRecord::Migration
  def change
    create_table :big_tournaments do |t|
      t.string :name, default: '' # TODO: проверить, действительно ли нужно для стринга указывать дефауль велью, или оно само и так укажется
      t.timestamps null: false
    end
  end
end
