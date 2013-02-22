OpenTurn::Application.routes.draw do
  get "chat_messages/create"

  get "chat_messages/show"

  get "tokens/create"
  get "tokens/destroy"

  devise_for :players, :controllers => { :sessions => "api/v1/sessions" }
  devise_scope :player do
    namespace :api do
      namespace :v1 do
        resources :sessions, :only => [:create, :destroy]
      end
    end
  end
  
  namespace :api do
    namespace :v1  do
      resources :tokens,:only => [:create, :destroy]
      resources :friendships
      resources :invitations
      resources :players, :only => [:create, :show]
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
