# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
u = User.create(email: 'ckloh.2012@sis.smu.edu.sg', first_name: 'Chung Kit', last_name: 'Loh', password: '123123123')
u.confirm_email!
u2 = User.create(email: 'choryi.poon.2012@sis.smu.edu.sg', first_name: 'Choryi', last_name: 'Poon', password: '123123123')
u2.confirm_email!
ac = AccessCode.create(code: 'midterms', test_id: 1, permits: 5)
cu = CodeUsage.create(access_code_id: ac.id, test_id: 1, email: "ckloh.2012@sis.smu.edu.sg", user_id: u.id)
cu.use!(u)
cu.complete!
cu2 = CodeUsage.create(access_code_id: ac.id, test_id: 1, email: "choryi.poon.2012@sis.smu.edu.sg", user_id: u2.id)
cu2.use!(u2)

e = Educator.create(email: 'rusydi@reactor.sg', password: '123123123', password_confirmation: '123123123', admin: true)
