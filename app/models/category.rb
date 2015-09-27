class Category < ActiveRecord::Base
  belongs_to :test
  has_many :questions
end
