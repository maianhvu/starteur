# Add seed content here
query = <<-SQL
UPDATE questions q SET scale=7 WHERE array_length(q.choices, 1) > 2
SQL
ActiveRecord::Base.connection.execute(query)
