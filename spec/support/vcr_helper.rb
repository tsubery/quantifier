VCR.configure do |c|
  c.cassette_library_dir = "support/vcr_cassettes"
  c.hook_into :webmock
  c.ignore_hosts "codeclimate.com"
end
