Dumper::Agent.start_if(:app_key => Rails.application.secrets.dumper_app_key) do
    Rails.env.production? && dumper_enabled_host?
end
