class Api::V1::TurnsController < ApplicationController
  def update
    @game = Game.find(params[:game_id])
    @turn = Turn.find(params[:id])

    if !@game.turns.include?(@turn)
      render :status=>406, :json=>{:message=>"Turn does not belong to game."}
    end

    if !@turn.player == current_player
      render :status=>406, :json=>{:message=>"Turn does not belong to player."}
    end

    if @turn.update_attributes(params[:turn])
      @turn.save

      # Once the turn is completed, create the next turn
      if @turn.completed
        
      end

    else
      render :status=>406, :json=>{:message=>"Unable to save turn."}
    end
  end
end