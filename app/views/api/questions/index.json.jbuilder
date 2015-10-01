json.array! @questions do |question|
  json.id question.id
  json.content question.content
  json.choices question.choices
end
