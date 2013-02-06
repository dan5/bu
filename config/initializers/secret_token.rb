# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Bu::Application.config.secret_token = (ENV['SECRET_TOKEN'] || 'f62a63ed98ea795768053e15b4af4eb7081b4c1c2aca9ac46ca63c255a072f8674fd6532a731145e8946069ece073b6f083df6fd96fbe4bd7d2b9850cb0c81e3')
