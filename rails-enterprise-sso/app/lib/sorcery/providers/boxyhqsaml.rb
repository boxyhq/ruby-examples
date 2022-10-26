module Sorcery
  module Providers
    # This class adds support for OAuth with BoxyHQ SAML.
    #
    #   config.boxyhqsaml.site = <http://localhost:5225>
    #   config.boxyhqsaml.key = <key>
    #   config.boxyhqsaml.secret = <secret>
    #   ...
    #
    class Boxyhqsaml < Base
      include Protocols::Oauth2

      attr_reader :parse
      attr_accessor :auth_url, :token_url, :user_info_path

      def initialize
        super

        @site          = ENV['JACKSON_URL']
        @auth_url      = '/api/oauth/authorize'
        @token_url     = '/api/oauth/token'
        @user_info_path = '/api/oauth/userinfo'
        @parse = :json
        # @state = SecureRandom.hex(16)
      end

      def get_user_hash(access_token)
        response = access_token.get(user_info_path)
        body = JSON.parse(response.body)
        auth_hash(access_token).tap do |h|
          h[:user_info] = body
          h[:uid] = body['id']
        end
      end

      # calculates and returns the url to which the user should be redirected,
      # to get authenticated at the external provider's site.
      def login_url(params, _session)
        add_param(authorize_url(authorize_url: auth_url),
                  [
                    { name: 'tenant', value: params[:tenant] },
                    { name: 'product', value: params[:product] }
                  ])
      end

      # tries to login the user from access token
      def process_callback(params, _session)
        args = {}.tap do |a|
          a[:code] = params[:code] if params[:code]
        end
        get_access_token(args, token_url: token_url, token_method: :post, auth_scheme: :request_body)
      end

      def add_param(url, query_params)
        uri = URI(url)
        qp = URI.decode_www_form(uri.query || [])
        query_params.each do |param|
          qp << [param[:name], param[:value]]
        end
        uri.query = URI.encode_www_form(qp)
        uri.to_s
      end
    end
  end
end
