json.array! @test_data do |test|
  json.id test[:id]
  json.name test[:name]
  json.accessCode test[:access_code] if test[:access_code]
  json.status do
    json.purchased test[:purchased]
    json.completed test[:completed]
  end
  json.description test[:description] if test[:description]
  json.price test[:price]
end
