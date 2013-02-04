class Game < ActiveRecord::Base
  
  AVAILABLE_STATES = { 
    :lobby => 0, 
    :started => 1, 
    :ended => 2 
  }

  attr_accessible :state, :invite_only
  has_many :games_players
  has_many :players, :through => :games_players
  has_many :turns
  has_many :invitations
  has_many :chat_messages

  # => [:medical, :unkwnown]
  def self.states
    Game::AVAILABLE_STATES.keys.sort
  end

  # => 3
  def self.state_value(key)
    self::AVAILABLE_STATES[key]
  end

  def recent_turns
    turns = self.turns.sort_by{|s| s[:created_at]}.reverse.first(self.players.count)
  end

  def create_initial_turn
    # Create the round robin schedule
    x = 0
    first_player = nil
    self.games_players.shuffle.each do |player|
      if x == 0
        first_player = player.player
      end
      player.turn_order = x 
      player.save
      x = x + 1
    end

    # Create the initial turn
    turn = Turn.new(:completed => false)
    turn.game = self
    turn.player = first_player
    turn.save
  end

end
