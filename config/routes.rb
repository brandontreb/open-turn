OpenTurn::Application.routes.draw do
  get "chat_messages/create"

  get "chat_messages/show"

  get "tokens/create"
  get "tokens/destroy"

  devise_for :players
  
  namespace :api do
    namespace :v1  do
      resources :tokens,:only => [:create, :destroy]
      resources :friendships
      resources :invitations
      resources :players, :only => [:create]
      get 'games/join'
      resources :games do
        get 'join'
        get 'start'
        resources :turns do
          post :append, :action => :update          
        end
        resources :invitations
        resources :chat_messages
      end      
    end
  end

end
