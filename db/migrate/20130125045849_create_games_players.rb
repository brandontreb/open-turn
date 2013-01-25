class CreateGamesPlayers < ActiveRecord::Migration
  def change
    create_table :games_players do |t|
      t.integer :player_id
      t.integer :game_id
      t.integer :turn_order
      t.text :meta
      t.timestamps
    end
  end
end
