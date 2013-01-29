class AddInviteOnlyToGames < ActiveRecord::Migration
  def change
    add_column :games, :invite_only, :boolean, :default => false
  end
end
