# Add seed content here
starteur_profiling_assessment = Test.where("name ILIKE '%Starteur Profiling Assessment%'").first
starteur_profiling_assessment.publish!
