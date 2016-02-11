json.questions(@questions) do |question|
  json.extract! question, :id, :content, :choices, :polarity
end
json.answeredCount @answered_count
