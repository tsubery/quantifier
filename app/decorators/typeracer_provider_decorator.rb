class TyperacerProviderDecorator < ProviderDecorator
  def extra_status
    "configured user id: #{uid}"
  end
end
