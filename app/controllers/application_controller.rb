class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :user_signed_in?

  private
    def current_user
      @current_user ||= User.find_by beeminder_user_id: session[:beeminder_user_id]
    end

    def user_signed_in?
      !!current_user
    end

    def authenticate_user!
      unless current_user
        redirect_to root_url, :alert => 'You need to sign in for access to this page.'
      end
    end

end
