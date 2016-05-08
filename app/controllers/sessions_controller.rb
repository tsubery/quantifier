class SessionsController < ApplicationController
  def new
    redirect_to "/auth/beeminder"
  end

  def create
    auth = request.env.fetch "omniauth.auth"
    credential = IdentityResolver.new(current_user, auth).credential

    if credential
      session[:beeminder_user_id] = credential.user.beeminder_user_id
      flash = "Connected successfully."
    else
      flash = "Please sign in first."
    end
    redirect_to root_url, notice: flash
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "Signed out!"
  end

  def failure
    redirect_to root_url, alert: "Authentication error: #{params[:message].humanize}"
  end
end
