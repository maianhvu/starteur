json.array! @tests do |test|
  json.name test.name
  json.status do
    json.purchased @user.purchased?(test)
    json.compeleted @user.completed?(test)
  end
  json.description test.description if test.description
  json.price test.price
end
