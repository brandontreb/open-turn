class Game < ActiveRecord::Base
  
  AVAILABLE_STATES = { 
    :lobby => 0, 
    :started => 1, 
    :ended => 2 
  }

  attr_accessible :state
  has_many :games_players
  has_many :players, :through => :games_players
  has_many :turns

  # => [:medical, :unkwnown]
  def self.states
    Game::AVAILABLE_STATES.keys.sort
  end

  # => 3
  def self.state_value(key)
    self::AVAILABLE_STATES[key]
  end

  def recent_turns
    turns = self.turns.sort_by{|s| s[:created_at]}.reverse.first(self.players.count-1)
  end

end
