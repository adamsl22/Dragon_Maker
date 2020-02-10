class CreateRaids < ActiveRecord::Migration[6.0]
  def change
    create_table :raids do |t|
      t.integer :village_id
      t.integer :dice_roll
      t.integer :game_id
    end
  end
end
