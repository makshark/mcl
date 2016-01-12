class AddCommentToGame < ActiveRecord::Migration
  def change
    add_column :games, :comment, :text
  end
end
