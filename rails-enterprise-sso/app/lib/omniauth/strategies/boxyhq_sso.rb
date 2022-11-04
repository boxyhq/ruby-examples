module OmniAuth
    module Strategies
        class BoxyhqSso < OmniAuth::Strategies::OAuth2
            # strategy name
            option :name, "boxyhq_sso"
            
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

            # Build the API credentials hash with returned auth data.
            credentials do
              credentials = {
                'token' => access_token.token,
                'expires' => true
              }
      
              if access_token.params
                credentials.merge!(
                  'id_token' => access_token.params['id_token'],
                  'token_type' => access_token.params['token_type'],
                  'refresh_token' => access_token.refresh_token
                )
              end
      
              # Retrieve and remove authorization params from the session
              session_authorize_params = session['authorize_params'] || {}
              session.delete('authorize_params')
      
              auth_scope = session_authorize_params[:scope]
              if auth_scope.respond_to?(:include?) && auth_scope.include?('openid')
                # Make sure the ID token can be verified and decoded.
                jwt_validator.verify(credentials['id_token'], session_authorize_params)
              end
      
              credentials
            end
            
            info do
              {
                :name => raw_info['name'],
                :email => raw_info['email']
              }
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
              @raw_info ||= access_token.get('/me').parsed
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