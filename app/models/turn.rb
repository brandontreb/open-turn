class Turn < ActiveRecord::Base
  attr_accessible :completed, :game_id, :player_id, :state_info
  belongs_to :game_id
  belongs_to :player
end
