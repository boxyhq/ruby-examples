module OmniAuth
    module Strategies
        class Boxyhqsso < OmniAuth::Strategies::OAuth2
            # strategy name
            option :name, "boxyhqsso"
            
            args %i[
              client_id
              client_secret
              domain
            ]

            # Setup client URLs used during authentication
            def client
              options.client_options.site = domain_url
              options.client_options.authorize_url = '/api/oauth/authorize'
              options.client_options.token_url = '/api/oauth/token'
              options.client_options.userinfo_url = '/api/oauth/userinfo'
              super
            end            

            # These are called after authentication has succeeded. If
            # possible, you should try to set the UID without making
            # additional calls (if the user id is returned with the token
            # or as a URI parameter). This may not be possible with all
            # providers.
            uid{ raw_info['id'] }

            
            info do
              {
                :name => raw_info['name'],
                :email => raw_info['email']
              }
            end

            # Define the parameters used for the /authorize endpoint
            def authorize_params
              params = super
              %w[connection connection_scope prompt screen_hint login_hint organization invitation ui_locales].each do |key|
                params[key] = request.params[key] if request.params.key?(key)
              end
      
              # Generate nonce
              params[:nonce] = SecureRandom.hex
      
              # Store authorize params in the session for token verification
              session['authorize_params'] = params.to_hash
      
              params
            end            

            extra do
              {
                'raw_info' => raw_info
              }
            end

            # Declarative override for the request phase of authentication
            def request_phase
              if no_client_id?
                # Do we have a client_id for this Application?
                fail!(:missing_client_id)
              elsif no_client_secret?
                # Do we have a client_secret for this Application?
                fail!(:missing_client_secret)
              elsif no_domain?
                # Do we have a domain for this Application?
                fail!(:missing_domain)
              else
                # All checks pass, run the Oauth2 request_phase method.
                super
              end
            end

            def raw_info
              userinfo_url = options.client_options.userinfo_url
              @raw_info ||= access_token.get(userinfo_url).parsed
            end

            # Check if the options include a client_id
            def no_client_id?
              ['', nil].include?(options.client_id)
            end
      
            # Check if the options include a client_secret
            def no_client_secret?
              ['', nil].include?(options.client_secret)
            end
      
            # Check if the options include a domain
            def no_domain?
              ['', nil].include?(options.domain)
            end

            # Normalize a domain to a URL.
            def domain_url
              domain_url = URI(options.domain)
              domain_url = URI("https://#{domain_url}") if domain_url.scheme.nil?
              domain_url.to_s
            end            
        end
    end
end