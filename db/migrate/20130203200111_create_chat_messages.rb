class CreateChatMessages < ActiveRecord::Migration
  def change
    create_table :chat_messages do |t|
      t.integer :player_id
      t.integer :game_id
      t.string :message

      t.timestamps
    end
  end
end
