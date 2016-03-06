# Add seed content here
test = Test.where("name ILIKE '%Starteur Profiling Assessment%'").first
test.categories.each do |category|
  category.alias = category.title.gsub(/(\s+|-+)/, "_").downcase
  category.save!
end
