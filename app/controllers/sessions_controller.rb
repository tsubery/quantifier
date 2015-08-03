class SessionsController < ApplicationController
  def new
    redirect_to "/auth/beeminder"
  end

  def create
    auth = request.env.fetch "omniauth.auth"
    resolver = IdentityResolver.new current_user, auth

    if (user = resolver.sign_in_user)
      session[:beeminder_user_id] = user.beeminder_user_id
    end
    redirect_to root_url, notice: resolver.flash
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "Signed out!"
  end

  def failure
    redirect_to root_url, alert: "Authentication error: #{params[:message].humanize}"
  end
end
