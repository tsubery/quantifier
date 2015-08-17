class MainController < ApplicationController
  expose(:supported_providers)
  def welcome
    redirect_to providers_path if current_user
  end

  def about
  end
end
