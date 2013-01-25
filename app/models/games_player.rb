class GamesPlayer < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  attr_accessible :meta, :turn_order
end
