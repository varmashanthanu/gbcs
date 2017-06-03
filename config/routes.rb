Rails.application.routes.draw do
  get 'welcome/home'

  get 'welcome/contact_us'

  get 'welcome/about_us'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root to: 'welcome#home'
end
