class MainController < ApplicationController
  def welcome
    redirect_to providers_path if current_user
  end

  def about
  end
end
