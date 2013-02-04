class Player < ActiveRecord::Base

  default_scope includes(:games_players).order('games_players.turn_order ASC')

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :games_players
  has_many :games, :through => :games_players
  has_many :turns
  has_many :chat_messages

  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :player

  has_many :invitations
  has_many :sent_invitations, :through => :invitations, :source => :player
  has_many :received_invitations, :class_name => "Invitation", :foreign_key => "invited_player_id"


end
