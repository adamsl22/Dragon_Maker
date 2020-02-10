class AddMpiToGameData < ActiveRecord::Migration[6.0]
  def change
    add_column :game_data, :mpi, :integer
  end
end
