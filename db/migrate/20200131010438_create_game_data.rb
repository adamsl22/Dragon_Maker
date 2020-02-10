class CreateGameData < ActiveRecord::Migration[6.0]
  def change
    create_table :game_data do |t|
      t.string :player_name
      t.integer :turn
      t.integer :eggs
      t.integer :score
    end
  end
end
