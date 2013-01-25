object @game

attributes :id, :state

child :players do
  extends 'api/v1/players/show'
end