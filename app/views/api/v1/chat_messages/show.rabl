object @chat_message

attributes :id, :message

child :player do
  extends 'api/v1/players/show'
end