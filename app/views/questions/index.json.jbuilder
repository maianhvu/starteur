json.questions(@questions) do |question|
  json.extract! question,
    :id,
    :content,
    :choices,
    :polarity,
    :scale
end
json.answeredCount @answered_count
