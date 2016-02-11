namespace :db do
  namespace :seed do
    # individual files
    Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |filename|
      task_name = File.basename(filename, '.rb').intern
      task task_name => :environment do
        load(filename) if File.exist?(filename)
      end
    end

    # add files
    task :all => :environment do
      Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |filename|
        load(filename) if File.exists?(filename)
      end
    end
  end
end
