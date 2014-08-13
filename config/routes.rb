Prelaunchr::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root :to => "users#new"

  post 'users/create', to: 'users#create'
  get 'refer-a-friend', to: 'users#refer'
  get 'privacy-policy', to: 'users#policy'

  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'users#redirect', :format => false, :via => :all
  end

end
