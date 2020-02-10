class AddTpToGameData < ActiveRecord::Migration[6.0]
  def change
    add_column :game_data, :tp, :integer
  end
end
