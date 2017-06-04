Rails.application.routes.draw do
  get 'users/index'

  get 'users/show'

  get 'users/edit'

  get 'users/update'

  get 'welcome/home'

  get 'welcome/contact_us'

  get 'welcome/about_us'



  devise_for :users#, controllers: {confirmations: 'users/confirmations', passwords: 'users/passwords', registrations: 'users/registrations', sessions: 'users/sessions', unlocks: 'users/unlocks'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users

  root to: 'welcome#home'
end
