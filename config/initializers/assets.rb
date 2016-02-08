# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
additional_assets = %w(
  starteur_application.css starteur_application.js

  starteur_webapp/landing.scss home/landing.js
  starteur_webapp/subpages.scss
  starteur_webapp/dashboard.scss

  landing/*.png shared/*.png
  dasboard/*.svg

  educators/**/*.css
  educators/*.js
)

Rails.application.config.assets.precompile.push(*additional_assets)
