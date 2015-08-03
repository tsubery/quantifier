RSpec.configure do |config|
  excluded_tables = %w(provider_names)
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, except: excluded_tables)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation, { except: excluded_tables }
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end
