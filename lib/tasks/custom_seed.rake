require 'pathname'

namespace :db do
  namespace :seed do

    def self.all_seed_files
      Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')]
    end

    # individual files
    all_seed_files.each do |filepath|
      task_name = File.basename(filepath, '.rb').intern
      task task_name => :environment do
        load(filepath) if File.exist?(filepath)
      end
    end

    # add files
    task :all => :environment do
      print "run all seed files?(y/n) "
      answer = STDIN.gets.chomp.downcase
      if answer.eql?('y')
        all_seed_files.sort.each do |filepath|
          load(filepath) if File.exists?(filepath)
        end
      end
    end

    # latest file
    task :last => :environment do
      filepath = all_seed_files.sort.last
      filename = Pathname.new(filepath).basename.to_s
      print "run file '#{filename}'?(y/n) "
      answer = STDIN.gets.chomp.downcase
      if answer.eql?('y')
        load(filepath) if File.exists?(filepath)
      end
    end

  end
end

