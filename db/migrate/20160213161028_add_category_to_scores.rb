class AddCategoryToScores < ActiveRecord::Migration
  def change
    add_reference :scores, :category, index: true, foreign_key: true
  end
end
