class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: { safari: "14.1", firefox: "89", chrome: "91", edge: "91", ie: false }
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Devise::Controllers::Helpers

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end
end
