class AddStudentsLeagueToGame < ActiveRecord::Migration
  def change
    add_column :games, :students_league, :boolean, default: false
  end
end
