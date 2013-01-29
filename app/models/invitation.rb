class Invitation < ActiveRecord::Base
  belongs_to :player
  belongs_to :invited_player, :class_name => "Player"
  belongs_to :game
  attr_accessible :game_id, :invited_player_id, :player_id
end
