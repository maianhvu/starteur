test = Test.find_by(name: 'Starteur Profiling Assessment')

AccessCode.create!(
  code: "MNO2009TestCode",
  test: test,
  universal: true
)

