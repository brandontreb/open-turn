class AddFacebookAccessTokenToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :facebook_access_token, :string
  end
end
