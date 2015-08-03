class GooglefitProviderDecorator < ProviderDecorator
  def extra_status
    last_ts = goal.params["modified_time_millis"]
    last_ts &&= Time.zone.at(last_ts / 1000)
    "Last update on #{last_ts}"
  end
end
