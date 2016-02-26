# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
top_level_assets = %w(
  starteur_application.css starteur_application.js
)

sub_assets = %w(
  starteur_webapp/landing.scss landing/main.js
  starteur_webapp/subpages.scss
  starteur_webapp/dashboard.scss dashboard/payments.js
  starteur_webapp/tests.scss tests/main.js
)

graphical_assets = %w(
  landing/*.png
  shared/*.png shared/*.svg
  dashboard/*.svg
  report/*.svg
)

educator_assets = %w(
  educators/**/*.css
  educators/*.js
)

Rails.application.config.assets.precompile
  .push(*top_level_assets)
  .push(*sub_assets)
  .push(*graphical_assets)
  .push(*educator_assets)
