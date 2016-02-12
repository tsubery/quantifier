Dumper::Agent.start_if(
    app_key: Rails.application.secrets.dumper_app_key
) { Rails.env.production? }
