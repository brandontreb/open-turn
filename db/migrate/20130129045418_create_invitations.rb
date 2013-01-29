class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :player_id
      t.integer :invited_player_id
      t.integer :game_id

      t.timestamps
    end
  end
end
