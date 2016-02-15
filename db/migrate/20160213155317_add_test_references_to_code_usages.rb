class AddTestReferencesToCodeUsages < ActiveRecord::Migration
  def change
    add_reference :code_usages, :test, index: true, foreign_key: true

    update_code_usages_query = <<-SQL
    UPDATE code_usages SET
    test_id=access_codes.test_id FROM access_codes
    WHERE access_code_id=access_codes.id
    SQL
    connection.execute(update_code_usages_query)
  end
end
