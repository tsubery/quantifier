class MainController < ApplicationController
  def welcome
    if current_user
      redirect_to providers_path
    end
  end
  def about

  end
end
