OpenTurn::Application.routes.draw do
  get "tokens/create"
  get "tokens/destroy"

  devise_for :players
  
  namespace :api do
    namespace :v1  do
      resources :tokens,:only => [:create, :destroy]
      resources :friendships
      resources :invitations
      get 'games/join'
      resources :games do
        get 'join'
        get 'start'
        resources :turns
        resources :invitations
      end      
    end
  end

end
