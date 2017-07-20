Rails.application.routes.draw do

  devise_for :users#, controllers: {registrations: 'users/registrations'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    match 'admin/make_admin' => 'admin#make_admin', as: :admin_make_admin, via: [:get]
    match 'admin/get_pass' => 'admin#get_pass', as: :admin_get_pass, via: [:get]

  resources :competitions do
    collection do
      get :select_team, :join_comp, :leave_comp
    end
  end

  resources :invites, only: [:new, :create, :destroy] do
    collection do
      get :mass_invite
    end
  end

  resources :members, only: [:destroy] do
    member do
      get :join
    end
  end

  resources :preferences, only: [:edit, :update]
  resources :programs

  resources :simulations, only: [:index, :new] do
    collection do
      get :team_skills, :remove_member, :search
    end
    member do
      get :user_stats
    end
  end

  resources :skills do
    collection do
      get :pie_chart
    end
  end

  resources :teams do
    collection do
      get :mine
    end
  end

  resources :users do
    collection do
      get :dashboard, :edit_avatar, :edit_password
      post  :update_password
    end
    member do
      get :column_graph, :indi_graph
    end
  end

  resources :user_skills, except: :show

  get 'welcome/home'
  get 'welcome/contact_us'
  get 'welcome/about_us'

  resources :yes_lists do
    collection do
      get :difficult_graph, :hated_graph
    end
    member do
      get :toggle
    end

  end

  root to: 'welcome#home'
end


####
# get 'yes_lists/:id/toggle' => 'yes_lists#toggle', as: :toggle_yes_lists, via: [:get]
# match 'difficult_graph/yes_lists' => 'yes_lists#difficult_graph', as: :difficult_graph_yes_lists, via: [:get]
# match 'hated_graph/yes_lists' => 'yes_lists#hated_graph', as: :hated_graph_yes_lists, via: [:get]


####
# stuff transfered under the resources blocks
# match 'team_skills/simulations' => 'simulations#team_skills', as: :simulations_team_skills, via: [:get]
# match 'search/simulations' => 'simulations#search', as: :simulations_search, via: [:get]
# match 'remove_member/simulations' => 'simulations#remove_member', as: :simulations_remove_member, via: [:get]
# match 'user_stats/:id/simulations' => 'simulations#user_stats', as: :simulations_user_stats, via: [:get]

# Additional routes.
# get 'members/:id/join' => 'members#join', as: :members_join, via: [:get]
# get 'welcome/home'
# get 'welcome/contact_us'
# get 'welcome/about_us'

# match 'users/:id/edit_password' => 'users#edit_password', as: :user_edit_password, via: [:get]
# match 'users/update_password' => 'users#update_password', as: :user_update_password, via: [:post]
# match 'user/dashboard' => 'users#dashboard', as: :user_dashboard, via: [:get]
# match 'user/edit_avatar' => 'users#edit_avatar', as: :user_edit_avatar, via: [:get]
# match 'column_graph/:id/users' => 'users#column_graph', as: :column_graph_users, via: [:get]
# match 'indi_graph/:id/users' => 'users#indi_graph', as: :indi_graph_users, via: [:get]

# match 'pie_chart/skills' => 'skills#pie_chart', as: :pie_chart_skills, via: [:get]
# get 'yes_lists/:id/toggle' => 'yes_lists#toggle', as: :toggle_yes_lists, via: [:get]
# match 'difficult_graph/yes_lists' => 'yes_lists#difficult_graph', as: :difficult_graph_yes_lists, via: [:get]
# match 'hated_graph/yes_lists' => 'yes_lists#hated_graph', as: :hated_graph_yes_lists, via: [:get]
# match 'select_team/competitions' => 'competitions#select_team', as: :select_team_competitions, via: [:get]
# match 'join_comp/competitions' => 'competitions#join_comp', as: :join_comp_competitions, via: [:get]
# match 'leave_comp/competitions' => 'competitions#leave_comp', as: :leave_comp_competitions, via: [:get]

# get 'mine/teams' => 'teams#mine', as: :teams_mine, via: [:get]

# match 'admin/make_admin' => 'admin#make_admin', as: :admin_make_admin, via: [:get]
# match 'admin/get_pass' => 'admin#get_pass', as: :admin_get_pass, via: [:get]

# match 'mass_invite/invites' => 'invites#mass_invite', as: :invites_mass_invite, via: [:get]


#####
  # Probably do not need any of this nonsense:-
  # match 'members/join' => 'members#join', as: :members_join, via: [:get]
  # match 'members/leave' => 'members#leave', as: :members_leave, via: [:get]
  # match 'invites/invite' => 'invites#invite', as: :invites_invite, via: [:get]
  # match 'invites/send' => 'invites#send', as: :invites_send, via: [:get]
  # match 'invites/reject' => 'invites#reject', as: :invites_reject, via: [:get]

  # UserSkills default routes list -> managed under 'resources'
  # get 'user_skills/index'
  # get 'user_skills/new'
  # match 'user_skills/create' => 'user_skills#create', as: :user_skills_create, via: [:post]
  # get 'user_skills/edit'
  # get 'user_skills/update'
  # get 'user_skills/destroy'

  # Competitions default routes list -> managed under 'resources'
  # get 'competitions/index'
  # get 'competitions/:id/show' => 'competitions#show', as: :competition, via: [:get]
  # get 'competitions/new'
  # match 'competitions/create' => 'competitions#create', as: :competitions_create, via: [:post]
  # get 'competitions/edit'
  # get 'competitions/update'
  # get 'competitions/destroy'

  # Users default routes list -> managed under 'resources'
  # get 'users/index'
  # get 'users/show'
  # get 'users/edit'
  # get 'users/update'
  # get 'users/edit_password' => 'users#edit_password'

  # YesLists default routes list -> managed under 'resources'
  # get 'yes_lists/new'
  # get 'yes_lists/create'
  # get 'yes_lists/index'
  # get 'yes_lists/edit'
  # get 'yes_lists/update'
  # get 'yes_lists/destroy'