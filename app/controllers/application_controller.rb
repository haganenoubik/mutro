class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 新規登録時のストロングパラメータ
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

    # プロフィール編集時のストロングパラメータ
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :bio])
  end
end
