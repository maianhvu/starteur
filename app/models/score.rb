class Score < ActiveRecord::Base
  belongs_to :user
  belongs_to :test
  belongs_to :category
  belongs_to :result
end
