# frozen_string_literal: true

Rails.application.routes.draw do
  resources :cars
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_for :users
  resources :people

  # Defines the root path route ("/")
  root 'people#index'
end
