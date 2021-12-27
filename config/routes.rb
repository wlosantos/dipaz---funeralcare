require 'api_version_constraint'

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth'
  namespace :api, defaults: { format: :json }, path: '/' do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
      resources :companies, only: %i[index update] do
        resources :registers, only: %i[index show create update destroy]
      end
    end
  end
end
