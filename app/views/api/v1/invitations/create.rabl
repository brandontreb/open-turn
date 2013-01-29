object @invitation

child :player do
  extends 'api/v1/players/show'
end

child :invited_player do
  extends 'api/v1/players/show'
end

child :game do
  extends 'api/v1/games/show'
end