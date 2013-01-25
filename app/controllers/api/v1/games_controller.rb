class Api::V1::GamesController < ApplicationController
  before_filter :authenticate_player!

  def index
    @games = Game.all
  end

  def join
    @game = Game.find(params[:game_id])
    if @game.players.count < APP_CONFIG['max_players']
      
      unless @game.players.include?(current_player)
        @game.players << current_player
      end
      
      if @game.players.count == APP_CONFIG['max_players'] &&
        @game.state != Game.status_value(:started)
        @game.update_attributes(:state => Game.state_value(:started))
        @game.save
        # TODO: Push to all users that the game has started
      end
    end
  end

end