require "omniauth-oauth"
require "multi_json"
require "securerandom"

module OmniAuth
  module Strategies
    class Quizlet < OmniAuth::Strategies::OAuth2
      option :name, "quizlet"
      option :client_options,         site: "https://quizlet.com",
                                      authorize_url: "/authorize",
                                      token_url: "https://api.quizlet.com/oauth/token"

      # Set the uid
      uid { access_token.params["user_id"] }

      # Set some simple user details from the API. Unfortunately, quizlet doesn't
      # really give us much, no name or emamil :(
      info do
        {
          username: raw_info["username"],
          image: raw_info["profile_image"]
        }
      end

      extra do
        { raw_info: raw_info }
      end

      # Build the raw_info by making an API call to the user page
      def raw_info
        user = access_token.params["user_id"]
        @raw_info ||= MultiJson.load(access_token.get("https://api.quizlet.com/2.0/users/#{user}").body)
      end

      def auth_hash
        OmniAuth::Utils.deep_merge(super, client_params.merge(grant_type: "authorization_code"))
      end

      def request_phase
        options[:authorize_params] = client_params.merge(options[:authorize_params])
        super
      end

      def client_params
        # quizlet requires us to pass a 'state' which it will return to present CSRF attacks
        # scope => "read" can be changed based on what priveleges you want, this could probably
        # be moved to the config file
        { state: SecureRandom.hex(15), scope: "read", client_id: options[:client_id], redirect_uri: callback_url, response_type: "code" }
      end
    end
  end
end
