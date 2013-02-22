class Api::V1::PlayersController < ApplicationController
  def create
      @player = Player.new(params[:player])
      if !@player.save
        render :json => { :errors => @player.errors.full_messages }
        return
      end
    end
end
