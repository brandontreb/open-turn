class Api::V1::GamesController < ApplicationController
  before_filter :authenticate_player!

  def index
    @games = Game.all
  end

  def show
    puts params.to_s
  end

  def join  
    if params[:game_id]
      @game = findOpenGame(params[:game_id])
    else
      @game = findOpenGame()
    end
  end

  private

  def findOpenGame(game_id = 0)    
    # Join a specific game
    if game_id.to_i > 0
      @game = Game.find(game_id)
    else
      # Find the first/oldest open game
      @game = Game.find_by_state(Game.state_value(:lobby), :order => 'created_at')

      if @game.nil?
        # If no open games, start a new one
        @game = Game.create(:state => Game.state_value(:lobby))
      end

    end

    # Check if the game already has too many players
    if !@game.nil? && @game.players.count < APP_CONFIG['max_players']         
      # Make sure the game doesn't already have the logged in player playing   
      unless @game.players.include?(current_player)        
        # Add the player to the game
        @game.players << current_player
      end
      
      # Start the game if it's at the limit      
      if @game.players.count == APP_CONFIG['max_players'] &&
      @game.state != Game.state_value(:started)

        @game.state = Game.state_value(:started)
        @game.save

        # Create the round robin schedule
        x = 0
        first_player = nil
        @game.games_players.shuffle.each do |player|

          if x == 0
            first_player = player.player
          end

          player.turn_order = x 
          player.save

          x = x + 1
        end

        # Create the initial turn
        turn = Turn.new(:completed => false)
        turn.game = @game
        turn.player = first_player
        turn.save

        # TODO: Push to all users that the game has started
        # TODO: Push to the player who's turn is first

      else
        # TODO: Push to all players that player has joined        
      end
    end
    return @game
  end
end