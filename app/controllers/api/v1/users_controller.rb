class Api::V1::UsersController < ApplicationController

  def create
    @user = User.new(params[:user])
    if !@user.save
      render :json => { :errors => @user.errors.full_messages }
      return
    end
  end

end