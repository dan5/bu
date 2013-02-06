Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, configatron.twitter_key, configatron.twitter_secret
end
