class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :configure_permited_parameters, if: :devise_controller?

  private

  def configure_permited_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: %i[name phone]
  end
end
