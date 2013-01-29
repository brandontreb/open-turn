class Api::V1::GamesController < ApplicationController
  before_filter :authenticate_player!

  def index
    @games = current_player.games
  end

  def show
    @game = Game.find(params[:id])
    if !current_player.games.include?(@game)
      render :status=>406, :json=>{:message=>"Invalid Game"}
    end
    @recent_turns = @game.recent_turns
  end

  def join  
    if params[:game_id]
      @game = findOpenGame(params[:game_id])
    else
      @game = findOpenGame()
    end
    @recent_turns = @game.recent_turns
  end

  def start
    puts "STARTING"
    @game = nil
    if !params[:game_id]
      render :status=>406, :json=>{:message=>"No game id provided"}
      return
    else
      @game = Game.find(params[:game_id])

      if @game.state == Game.state_value(:started)
        render :status=>406, :json=>{:message=>"The game has already started."}
      return
      end

      if @game.state == Game.state_value(:ended)
        render :status=>406, :json=>{:message=>"The game has already ended."}
      return
      end      
      
      @game.state = Game.state_value(:started)
      @game.save
      @game.create_initial_turn
    end
  end

  private
  def findOpenGame(game_id = 0)    
    # Join a specific game
    if game_id.to_i > 0
      @game = Game.find(game_id)
    else
      # Find the first/oldest open game
      @game = Game.find_by_state_and_invite_only(Game.state_value(:lobby), false, :order => 'created_at')

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

        @game.create_initial_turn()

        # TODO: Push to all users that the game has started
        # TODO: Push to the player who's turn is first

      else
        # TODO: Push to all players that player has joined        
      end
    else
      return findOpenGame()
    end
    return @game
  end  
end