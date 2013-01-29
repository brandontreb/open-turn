class Api::V1::FriendshipsController < ApplicationController
  before_filter :authenticate_player!
  def index
    @friendships = Friendship.find_all_by_player_id(current_player.id)
  end

  def create
    @friendship = current_player.friendships.build(:friend_id => params[:friend_id])
    if !@friendship.save
          render :json => { :errors => @friendship.errors.full_messages }
          return
    end
  end

  def destroy
    @friendship = current_player.friendships.find(params[:id])
    @friendship.destroy    
  end

end