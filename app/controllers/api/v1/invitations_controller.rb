class Api::V1::InvitationsController < ApplicationController
  before_filter :authenticate_player!
  def create
    if params[:game_id]

      begin
        @game = Game.find(params[:game_id])
      rescue      
        render json: {:error => "Game does not exist"}
        return
      end

      if !@game.players.include?(current_player)        
        render json: {:error => "You can't invite players to games you are not in"}
        return
      end

      if @game.state != Game.state_value(:lobby)
        render json: {:error => "This game has either started or has ended"}
        return
      end 

      if @game.invitations.find_by_invited_player_id(params[:invited_player_id])
        render json: {:error => "Invitation has already been sent"}
        return
      end

      @invitation = current_player.invitations.build(:invited_player_id => params[:invited_player_id])
      @invitation.game = @game
      @invitation.save

    else
      @game = Game.create(:state => Game.state_value(:lobby), :invite_only => true)      
      @game.players << current_player
      @invitation = current_player.invitations.build(:invited_player_id => params[:invited_player_id])
      @invitation.game = @game
      @invitation.save      
    end
    # TODO : Push invite to invited_player_id

  end
end