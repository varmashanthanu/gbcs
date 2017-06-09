Rails.application.routes.draw do
  # get 'user_skills/index'
  #
  # get 'user_skills/new'
  #
  # match 'user_skills/create' => 'user_skills#create', as: :user_skills_create, via: [:post]
  #
  # get 'user_skills/edit'
  #
  # get 'user_skills/update'
  #
  # get 'user_skills/destroy'

  get 'competitions/index'

  get 'competitions/:id/show' => 'competitions#show', as: :competition, via: [:get]

  get 'competitions/new'

  match 'competitions/create' => 'competitions#create', as: :competitions_create, via: [:post]

  get 'competitions/edit'

  get 'competitions/update'

  get 'competitions/destroy'

  get 'users/index'

  get 'users/show'

  get 'users/edit'

  get 'users/update'

  get 'welcome/home'

  get 'welcome/contact_us'

  get 'welcome/about_us'


  # get 'users/edit_password' => 'users#edit_password'
  match 'users/edit_password' => 'users#edit_password', as: :user_edit_password, via: [:get]
  match 'users/update_password' => 'users#update_password', as: :user_update_password, via: [:post]
  match 'users/make_admin' => 'users#make_admin', as: :make_admin, via: [:get]
  match 'user/dashboard' => 'users#dashboard', as: :user_dashboard, via: [:get]

  devise_for :users#, controllers: {registrations: 'users/registrations'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users

  resources :skills
  match 'pie_chart/skills' => 'skills#pie_chart', as: :pie_chart_skills, via: [:get]

  resources :user_skills

  root to: 'welcome#home'
end
