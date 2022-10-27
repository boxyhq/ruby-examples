module JacksonApi
    module V1
        class Client
            include HttpStatusCodes
            include ApiExceptions

            API_ENDPOINT = ENV['JACKSON_URL'].freeze
            API_KEY = ENV['JACKSON_API_KEYS'].freeze


            def create_sso_connection(connection)
                request(
                    http_method: :post,
                    endpoint: "api/v1/connections"
                )
            end

            private

            def client
              @_client ||= Faraday.new(API_ENDPOINT) do |client|
                client.request :url_encoded
                client.adapter Faraday.default_adapter
                client.headers['Authorization'] = "Api-Key #{API_KEY}" if API_KEY.present?
              end
            end
      
            def request(http_method:, endpoint:, params: {})
              response = client.public_send(http_method, endpoint, params)
              parsed_response = JSON.parse(response.body)

              return parsed_response if response_successful response ?

              raise error_class, "Code: #{response.status}, response: #{response.body}"
            end  
            
            def error_class
                case response.status
                when HTTP_BAD_REQUEST_CODE
                  BadRequestError
                when HTTP_UNAUTHORIZED_CODE
                  UnauthorizedError
                when HTTP_FORBIDDEN_CODE
                  return ApiRequestsQuotaReachedError if api_requests_quota_reached?
                  ForbiddenError
                when HTTP_NOT_FOUND_CODE
                  NotFoundError
                when HTTP_UNPROCESSABLE_ENTITY_CODE
                  UnprocessableEntityError
                else
                  ApiError
                end
            end

            def response_successful(response)?
                response.status == HTTP_OK_CODE
            end

        end
    end
end