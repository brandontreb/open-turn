class Player < ActiveRecord::Base

  default_scope includes(:games_players).order('games_players.turn_order ASC')

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :games_players
  has_many :games, :through => :games_players
  has_many :turns

end
