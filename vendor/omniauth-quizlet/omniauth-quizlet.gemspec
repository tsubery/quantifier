$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "omniauth-quizlet/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-quizlet"
  s.version     = Quizlet::VERSION
  s.authors     = ["John Koht"]
  s.email       = ["john@kohactive.com"]
  s.homepage    = "https://github.com/kohactive/omniauth-quizlet"
  s.summary     = "Quizlet OAuth strategy for OmniAuth"
  s.description = "Quizlet OAuth strategy for OmniAuth"

  s.require_paths = ["lib"]

  s.add_dependency "omniauth", "~> 1.0"
  s.add_runtime_dependency "omniauth-oauth2", "~> 1.0"
  s.add_runtime_dependency "multi_json"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
end
