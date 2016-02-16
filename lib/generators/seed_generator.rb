class SeedGenerator < Rails::Generators::NamedBase
  SEED_PATH = 'db/seeds'

  desc "This generator creates a seed file (timestamped) at #{SEED_PATH}"

  def create_seed_file
    timestamp = Time.now.strftime("%Y%m%d_%H%M%S_")
    create_file "#{SEED_PATH}/#{timestamp}#{file_name}.rb", '# Add seed content here'
  end
end
