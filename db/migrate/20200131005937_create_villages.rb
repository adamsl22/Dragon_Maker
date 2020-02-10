class CreateVillages < ActiveRecord::Migration[6.0]
  def change
    create_table :villages do |t|
      t.string :name
      t.integer :population
      t.integer :knights
      t.integer :slayers
      t.integer :game_id
    end
  end
end
