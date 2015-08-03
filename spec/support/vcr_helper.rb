VCR.configure do |c|
  c.cassette_library_dir = "support/vcr_cassettes"
  c.hook_into :webmock
end
