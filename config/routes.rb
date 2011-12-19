Strano::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
    get 'sign_in', :to => 'users/sessions#new', :as => :new_user_session
    delete 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
  end

  resources :projects do
    resources :jobs, :except => :new do
      get 'new/:task', :action => :new, :on => :collection, :as => :new
    end
  end

  root :to => "dashboard#index"

end
