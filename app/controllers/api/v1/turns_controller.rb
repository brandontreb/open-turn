class Api::V1::TurnsController < ApplicationController
  before_filter :authenticate_player!
  def update
    @game = Game.find(params[:game_id])

    turn_id = params.has_key?(:id) ? params[:id] : params[:turn_id] 
    @turn = Turn.find(turn_id)

    # Make sure its a live game
    if @game.state == Game.state_value(:ended)
      render :status=>406, :json=>{:message=>"This game has already ended."}
      return
    end

    # Make sure this turn belongs to this game
    if !@game.turns.include?(@turn)
      render :status=>406, :json=>{:message=>"Turn does not belong to game."}
      return
    end

    # Make sure the correct player is playing the turn
    if @turn.player != current_player
      render :status=>406, :json=>{:message=>"Turn does not belong to player."}
      return
    end

    # Make sure the turn hasn't already been completed
    if @turn.completed
      render :status=>406, :json=>{:message=>"Turn has already been completed."}
      return
    end

    if @turn.update_attributes(params[:turn])
      @turn.completed = true
      @turn.state_info = params[:state_info]
      @turn.save
      # Once the turn is completed, create the next turn
      if @turn.completed       
        if params[:game]
          @game.update_attributes(params[:game])
          @game.save
          if @game.state == Game.state_value(:ended)
            # TODO Push to everyone that the game has ended
          end          
        else
          # Generate next turn
          order = (@turn.player.games_players.find_by_game_id(@game.id).turn_order + 1) % @game.players.count
          next_player = @turn.game.games_players.find_by_turn_order(order).player
          @turn = Turn.new
          @turn.game =  @game
          @turn.player = next_player
          @turn.completed = false
          @turn.save
          # TODO: Push to the next player 
        end
      end
    else
      render :status=>406, :json=>{:message=>"Unable to save turn."}
      return
    end
  end
end