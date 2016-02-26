module SqlHelper
  def define_real_score_function
    ActiveRecord::Base.connection.execute(
    <<-SQL
    CREATE OR REPLACE FUNCTION real_score(answer_value integer, polarity integer, scale integer) RETURNS integer AS $$
    BEGIN
      RETURN ABS(answer_value + (polarity - 1) * (scale - 1) / 2);
    END;
    $$ LANGUAGE plpgsql;
    SQL
    )
  end
end
