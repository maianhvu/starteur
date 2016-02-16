json.questions(@questions) do |question|
  json.extract! question,
    :id,
    :content,
    :choices,
    :scale
end
json.answeredCount @answered_count
