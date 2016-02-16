class CreateRealScoreFunction < ActiveRecord::Migration
  def up
    connection.execute(
    <<-SQL
    CREATE OR REPLACE FUNCTION real_score(answer_value integer, polarity integer, scale integer) RETURNS integer AS $$
    BEGIN
    RETURN ABS(answer_value + (polarity - 1) * (scale - 1) / 2);
    END;
    $$ LANGUAGE plpgsql;
    SQL
    )
  end

  def down
    connection.execute(
    <<-SQL
    DROP FUNCTION IF EXISTS real_score
    SQL
    )
  end
end
