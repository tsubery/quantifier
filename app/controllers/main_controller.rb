class MainController < ApplicationController
  expose(:providers) {
    ProviderRepo.names.map{ |name| ProviderRepo.find(name)}
  }
  def welcome
  end

  def about
  end
end
