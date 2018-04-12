 # Set our app-stored secret key with Stripe
 Stripe.api_key = Rails.application.credentials.stripe[:secret_key]
