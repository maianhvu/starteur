class AddTestReferencesToAnswer < ActiveRecord::Migration
  def change
    add_reference :answers, :test, index: true, foreign_key: true
  end
end
