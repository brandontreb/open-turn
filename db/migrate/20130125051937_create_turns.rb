class CreateTurns < ActiveRecord::Migration
  def change
    create_table :turns do |t|
      t.integer :player_id
      t.text :state_info
      t.integer :game_id
      t.boolean :completed

      t.timestamps
    end
  end
end
