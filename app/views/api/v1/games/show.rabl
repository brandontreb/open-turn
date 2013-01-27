object @game
#collection @current_turns

attributes :id, :state

child :players do
  extends 'api/v1/players/show'
end

child @game.recent_turns do
  extends 'api/v1/turns/show'
end

#node @recent_turns do
#  extends 'api/v1/turns/show'
#end