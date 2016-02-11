module SQLHelper
  def raw_query(sql)
    query_result = ActiveRecord::Base.connection.execute(sql)
    query_result = query_result.values if query_result.respond_to? :values
  end

  def extract_count(result)
    result.flatten.first.to_i
  end
end
