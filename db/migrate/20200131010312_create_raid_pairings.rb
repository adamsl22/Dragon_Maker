class CreateRaidPairings < ActiveRecord::Migration[6.0]
  def change
    create_table :raid_pairings do |t|
      t.integer :raid_id
      t.integer :dragon_id
    end
  end
end
