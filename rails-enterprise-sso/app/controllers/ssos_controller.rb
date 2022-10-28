class SsosController <  ApplicationController
    skip_before_action :require_login

    TENANT='boxyhq.com'
    PRODUCT='saml-demo.boxyhq.com'

    def initialize
        super
        @jackson_client = JacksonApi::V1::Client.new
    end

    def index
        @connections = @jackson_client.retrieve_sso_connections(tenant: TENANT,product: PRODUCT)
    end

    def save_connection
        connection_parameters = {
            "tenant" => TENANT,
            "product" => PRODUCT,
            "redirectUrl" => ENV['APP_URL'],
            "defaultRedirectUrl" => ENV['APP_URL'] + '/oauth/callback',
            "rawMetadata" => params[:metadata]
        }
        
        @jackson_client.create_sso_connection(connection_parameters)

        redirect_to setup_sso_path
    end
end