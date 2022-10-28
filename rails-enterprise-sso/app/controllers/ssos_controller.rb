class SsosController <  ApplicationController
    skip_before_action :require_login

    def index
    end

    def save_connection
        jackson_client = JacksonApi::V1::Client.new
         
        connection_parameters = {
            "tenant" => 'boxyhq.com',
            "product" => 'saml-demo.boxyhq.com',
            "redirectUrl" => ENV['APP_URL'],
            "defaultRedirectUrl" => ENV['APP_URL'] + '/oauth/callback',
            "rawMetadata" => params[:metadata]
        }
        
        jackson_client.create_sso_connection(connection_parameters)
    end
end