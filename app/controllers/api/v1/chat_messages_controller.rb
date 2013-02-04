class Api::V1::ChatMessagesController < ApplicationController

  before_filter :authenticate_player!
  def create
    begin
      game = Game.find(params[:game_id])
    rescue      
      render json: {:error => "Game does not exist"}
      return
    end

    if !game.players.include?(current_player)        
      render json: {:error => "You are not in this game."}
      return
    end

    if game.state == Game.state_value(:ended)
      render json: {:error => "This game has ended"}
      return
    end
      
    @chat_message = game.chat_messages.build(params[:chat_message])
    @chat_message.player = current_player
    @chat_message.save
    
  end

  def show
  end
end
