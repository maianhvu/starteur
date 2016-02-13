class AddScaleToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :scale, :integer
  end
end
