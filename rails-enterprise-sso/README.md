# Rails Demo App with Single Sign-On (SSO)

This demo app shows how to add enterprise SSO to a rails app using the 'Jackson' service.

In this demo app, you will find integration code snippets with two well-known authentication libraries

- OmniAuth https://github.com/omniauth/omniauth
- Sorcery https://github.com/Sorcery/sorcery

## OmniAuth

See [`boxyhqsso`](app/lib/omniauth/strategies/boxyhqsso.rb) strategy which extends from [omniauth-oauth2](https://github.com/omniauth/omniauth-oauth2). The strategy is loaded as a [Rack middleware](config/initializers/omniauth.rb).

## Sorcery

See [`boxyhqsso`](app/lib/sorcery/providers/boxyhqsso.rb) provider which includes the mixin `Protocols::Oauth2` from the sorcery package. See the provider configuration [sorcery.rb](config/initializers/sorcery.rb)

---

## Getting started

### Setup Ruby development environment

You can use [rbenv](https://github.com/rbenv/rbenv) to install Ruby on your machine.

For this demo app, we are using ruby version `2.7.6`.

### Clone and install the dependencies

```bash
git clone https://github.com/boxyhq/ruby-examples.git
cd rails-enterprise-sso
bundle install
```

### Setup the env file

Copy the `.env.example` to `.env` and populate the values.

### Start the app

Run the rails server.

```bash
./bin/dev # This uses the Procfile.dev in the root folder to start the rails server
```

To access the app, open the URL http://localhost://3366 in the browser tab.
