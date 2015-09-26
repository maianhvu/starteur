json.array! @tests do |test|
  json.name test.name
  json.description test.description if test.description
  json.price test.price
end
