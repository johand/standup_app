# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :accounts
  get 'activity/mine'
  get 'activity/feed'
  root to: 'activity#mine'
end
