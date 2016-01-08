require 'csv'

namespace :csv do
  desc "Import User data"
  task :importusers => :environment do
  	User.delete_all
  	csv_file_path = 'db/data/users.csv'

  	CSV.foreach(csv_file_path) do |row|
      User.create!({
      	:id => row[0],
        :email => row[1],
        :password_digest => row[2],
        :first_name => row[3],  
        :last_name => row[4],
        :type => row[5],
        :created_at => row[6],
        :updated_at => row[7],
        :confirmation_token => row[8],
        :confirmed_at => row[9],
        :deactivated => row[10],
        :state => row[11]
      })
      puts "User #{row[1]} added!"
    end
  end

  task :importtests => :environment do
  	Test.delete_all
  	csv_file_path = 'db/data/tests.csv'

  	CSV.foreach(csv_file_path) do |row|
      Test.create!({
      	:id => row[0],
        :name => row[1],
        :description => row[2],
        :state => row[3],  
        :price => row[4],
        :created_at => row[5],
        :updated_at => row[6],
        :shuffle => row[7],
        :processor_file => row[8]
      })
      puts "Test #{row[1]} added!"
    end
  end

  desc "Import Category data"
  task :importcategories => :environment do
  	Category.delete_all
  	csv_file_path = 'db/data/categories.csv'

  	CSV.foreach(csv_file_path) do |row|
      Category.create!({
      	:id => row[0],
        :rank => row[1],
        :title => row[2],
        :test_id => row[4],
        :created_at => row[5],
        :updated_at => row[6],
        :symbol => row[7]
      })
      puts "Category #{row[2]} added!"
    end
  end

  desc "Import Questions data"
  task :importquestions => :environment do
  	Question.delete_all
  	csv_file_path = 'db/data/questions.csv'

  	CSV.foreach(csv_file_path) do |row|
      Question.create!({
      	:id => row[0],
        :content => row[2],
        :created_at => row[3],  
        :updated_at => row[4],
        :category_id => row[5],
        :choices => row[6],
        :polarity => row[7]
      })
      puts "Question #{row[2]} added!"
    end
  end

  desc "Import Answers data"
  task :importanswers => :environment do
  	Answer.delete_all
  	csv_file_path = 'db/data/answers.csv'

  	CSV.foreach(csv_file_path) do |row|
      Answer.create!({
      	:id => row[0],
        :user_id => row[1],
        :created_at => row[2],
        :updated_at => row[3],  
        :test_id => row[4],
        :question_id => row[5],
        :value => row[6]
      })
      puts "Answer for test #{row[4]} question #{row[5]} added!"
    end
  end

  desc "Import Access Code data"
  task :importaccesscodes => :environment do
  	AccessCode.delete_all
  	csv_file_path = 'db/data/accesscodes.csv'

  	CSV.foreach(csv_file_path) do |row|
      AccessCode.create!({
      	:id => row[0],
        :code => row[1],
        :test_id => row[2],
        :last_used_at => row[3],  
        :created_at => row[4],
        :updated_at => row[5],
        :educator_id => row[6],
        :permits => row[7]
      })
      puts "Row added!"
    end
  end

  desc "Import Code Usage data"
  task :importcodeusages => :environment do
  	CodeUsage.delete_all
  	csv_file_path = 'db/data/codeusages.csv'

  	CSV.foreach(csv_file_path) do |row|
      CodeUsage.create!({
      	:id => row[0],
        :access_code_id => row[1],
        :user_id => row[2],
        :created_at => row[3],  
        :updated_at => row[4],
        :state => row[5],
        :batch_id => row[6]
      })
      puts "Code Usage added!"
    end
  end
  
  desc "Import Results data"
  task :importresults => :environment do
  	Result.delete_all
  	csv_file_path = 'db/data/results.csv'

  	CSV.foreach(csv_file_path) do |row|
      Result.create!({
      	:id => row[0],
        :answers => row[1],
        :user_id => row[2],
        :test_id => row[3],  
        :code_usage_id => row[4],
        :created_at => row[5],
        :updated_at => row[6]
      })
      puts "Result for user #{row[2]} added!"
    end
  end

  desc "Import Authentication Tokens data"
  task :importtokens => :environment do
  	AuthenticationToken.delete_all
  	csv_file_path = 'db/data/authenticationtokens.csv'

  	CSV.foreach(csv_file_path) do |row|
      AuthenticationToken.create!({
      	:id => row[0],
        :token => row[1],
        :user_id => row[2],
        :expires_at => row[3],  
        :last_used_at => row[4],
        :created_at => row[5],
        :updated_at => row[6],
        :state => row[7]
      })
      puts "Token #{row[1]} added!"
    end
  end
  
  desc "Run all tasks"
  task :runall => [:importusers, :importtests, :importcategories, :importquestions, :importanswers, :importaccesscodes, :importcodeusages, :importresults, :importtokens ] do
    # This will run after all those tasks have run
  end
end
