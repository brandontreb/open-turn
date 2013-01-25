class Game < ActiveRecord::Base
  attr_accessible :state
  has_many :games_players
  has_many :players, :through => :games_players
  has_many :turns

  AVAILABLE_STATES = { :lobby => 0, :started => 1, :over => 2 }

  # => [:medical, :unkwnown]
  def self.states
    Game::AVAILABLE_STATES.keys.sort
  end

  # => 3
  def self.state_value(key)
    Game::AVAILABLE_STATES[:key]
  end

end
