# frozen_string_literal: true

Rails.application.routes.draw do
  get 's/new/(:date)', to: 'standups#new', as: 'new_standup'
  get 's/edit/(:date)', to: 'standups#edit', as: 'edit_standup'
  resources :standups, path: 's', except: %i[new edit]

  devise_for :users, controllers: { registrations: 'registrations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :accounts

  get 't/new', to: 'teams#new'
  get 't/:id/edit', to: 'teams#edit'
  get 't/:id/s', to: 'teams/standups#index', as: 'team_standups'
  get 't/:id/s/(:date)', to: 'teams/standups#index', as: 'team_standups_by_date'
  get 't/:id/(:date)', to: 'teams#show'
  resources :teams, path: 't'

  get 'user/me', to: 'users#me', as: 'my_settings'
  patch 'user/update_me', to: 'users#update_me', as: 'update_my_settings'
  get 'user/password', to: 'users#password', as: 'my_password'
  patch 'user/update_password', to: 'users#update_password', as: 'my_update_password'

  scope 'account', as: 'account' do
    resources :users do
      member do
        get 's', to: 'users/standups#index', as: 'standups'
      end
    end
  end

  get 'activity/mine'
  get 'activity/feed'
  get 'dates/:date', to: 'dates#update', as: 'update_date'
  root to: 'activity#mine'
end
