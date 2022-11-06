Rails.application.config.middleware.use OmniAuth::Builder do
    provider :developer unless Rails.env.production?
    provider(
        :boxyhqsso,
        'dummy',
        ENV['CLIENT_SECRET_VERIFIER'],
        ENV['JACKSON_URL'],
        callback_path: '/auth/boxyhq_sso/callback',
        authorize_params: {
            scope: 'openid'
        }
    )
end