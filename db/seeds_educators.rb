# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Case 1: Create educator1 - no batch / no test
educator1 = Educator.create!(email:'educator1@test.com',password:'test',password_confirmation:'test')

# Case 2: Create educator2 - no batch / 3 tests
educator2 = Educator.create!(email:'educator2@test.com',password:'test',password_confirmation:'test')

# Case 3: Create educator3 - 3 batches / 5 tests
educator3 = Educator.create!(email:'educator3@test.com',password:'test',password_confirmation:'test')

# Create 5 tests
MBTI = Test.create!(name: 'MBTI', description: 'This test indicates psychological preferences in how people perceive the world', price: 10)
Holland = Test.create!(name: 'Holland Codes', description: 'This test indicates careers and vocational choices', price: 20)
ONET = Test.create!(name: 'O*NET', description: 'This test indicates occupational aptitudes', price: 30)
DISC = Test.create!(name: 'DISC Assessment', description: 'This test indicates behavioral traits', price: 15)
PMAI = Test.create!(name: 'PMAI', description: 'This test indicates personality types and archetypes', price: 25)

# Create 3 batches for educator 3
batch1 = Batch.create!(educator: educator3, test: MBTI, name: 'batch1')
batch2 = Batch.create!(educator: educator3, test: ONET, name: 'batch2')
batch3 = Batch.create!(educator: educator3, test: DISC, name: 'batch3')

# Create 10 Access Codes for educator2 - MBTI
educator2_MBTI_accessCode1 = AccessCode.create!(code: '1Q2W3E4R', educator: educator2, test: MBTI, permits: 5)
educator2_MBTI_accessCode2 = AccessCode.create!(code: '2W3E4R5T', educator: educator2, test: MBTI, permits: 5)

# Create 20 Access Codes for educator2 - Holland
educator2_Holland_accessCode1 = AccessCode.create!(code: '3E4R5T6Y', educator: educator2, test: Holland, permits: 6)
educator2_Holland_accessCode2 = AccessCode.create!(code: '4R5T6Y7U', educator: educator2, test: Holland, permits: 4)
educator2_Holland_accessCode3 = AccessCode.create!(code: '5T6Y7U8I', educator: educator2, test: Holland, permits: 10)

# Create 30 Access Codes for educator2 - ONET
educator2_ONET_accessCode1 = AccessCode.create!(code: '6Y7U8I9O', educator: educator2, test: ONET, permits: 10)
educator2_ONET_accessCode2 = AccessCode.create!(code: '7U8I9O0P', educator: educator2, test: ONET, permits: 20)

# Create 15 Access Codes for educator3 - MBTI
educator3_MBTI_accessCode1 = AccessCode.create!(code: '1Q2W3E4R', educator: educator3, test: MBTI, permits: 4)
educator3_MBTI_accessCode2 = AccessCode.create!(code: '2W3E4R5T', educator: educator3, test: MBTI, permits: 11)

# Create 25 Access Codes for educator3 - Holland
educator3_Holland_accessCode1 = AccessCode.create!(code: '3E4R5T6Y', educator: educator3, test: Holland, permits: 5)
educator3_Holland_accessCode2 = AccessCode.create!(code: '4R5T6Y7U', educator: educator3, test: Holland, permits: 10)
educator3_Holland_accessCode3 = AccessCode.create!(code: '5T6Y7U8I', educator: educator3, test: Holland, permits: 10)

# Create 35 Access Codes for educator3 - ONET
educator3_ONET_accessCode1 = AccessCode.create!(code: '6Y7U8I9O', educator: educator3, test: ONET, permits: 15)
educator3_ONET_accessCode2 = AccessCode.create!(code: '7U8I9O0P', educator: educator3, test: ONET, permits: 20)

# Create 40 Access Codes for educator3 - DISC
educator3_DISC_accessCode1 = AccessCode.create!(code: '8I9O0PQA', educator: educator3, test: DISC, permits: 15)
educator3_DISC_accessCode2 = AccessCode.create!(code: '9O0PQAWS', educator: educator3, test: DISC, permits: 15)
educator3_DISC_accessCode3 = AccessCode.create!(code: '0PQAWSED', educator: educator3, test: DISC, permits: 10)

# Create 50 Access Codes for educator3 - PMAI
educator3_PMAI_accessCode1 = AccessCode.create!(code: 'QAWSEDRF', educator: educator3, test: PMAI, permits: 15)
educator3_PMAI_accessCode2 = AccessCode.create!(code: 'WSEDRFTG', educator: educator3, test: PMAI, permits: 35)

# Create 5 Code Usages for educator2 - MBTI
# 3 for accessCode1
codeUsage1 = CodeUsage.create!(access_code: educator2_MBTI_accessCode1)
codeUsage2 = CodeUsage.create!(access_code: educator2_MBTI_accessCode1)
codeUsage3 = CodeUsage.create!(access_code: educator2_MBTI_accessCode1)
# 2 for accessCode2
codeUsage4 = CodeUsage.create!(access_code: educator2_MBTI_accessCode2)
codeUsage5 = CodeUsage.create!(access_code: educator2_MBTI_accessCode2)

# Create 3 Code Usages for educator2 - Holland
# 1 for accessCode1
codeUsage6 = CodeUsage.create!(access_code: educator2_Holland_accessCode1)
# 1 for accessCode2
codeUsage7 = CodeUsage.create!(access_code: educator2_Holland_accessCode2)
# 1 for accessCode3
codeUsage8 = CodeUsage.create!(access_code: educator2_Holland_accessCode3)

# Create 4 Code Usages for educator2 - ONET
# 3 for accessCode1
codeUsage9 = CodeUsage.create!(access_code: educator2_ONET_accessCode1)
codeUsage10 = CodeUsage.create!(access_code: educator2_ONET_accessCode1)
codeUsage11 = CodeUsage.create!(access_code: educator2_ONET_accessCode1)
# 1 for accessCode2
codeUsage12 = CodeUsage.create!(access_code: educator2_ONET_accessCode2)

# Create 1 Code Usages for educator3 - MBTI
codeUsage13 = CodeUsage.create!(access_code: educator3_MBTI_accessCode1)

# Create 2 Code Usages for educator3 - Holland
# 1 for accesCode1
codeUsage14 = CodeUsage.create!(access_code: educator3_Holland_accessCode1)
# 1 for accesCode2
codeUsage15 = CodeUsage.create!(access_code: educator3_Holland_accessCode2)

# Create 3 Code Usages for educator3 - ONET
# 3 for accesCode1
codeUsage16 = CodeUsage.create!(access_code: educator3_ONET_accessCode1)
codeUsage17 = CodeUsage.create!(access_code: educator3_ONET_accessCode1)
codeUsage18 = CodeUsage.create!(access_code: educator3_ONET_accessCode1)

# Create 4 Code Usages for educator3 - ONET
# 2 for accesCode1
codeUsage19 = CodeUsage.create!(access_code: educator3_DISC_accessCode1)
codeUsage20 = CodeUsage.create!(access_code: educator3_DISC_accessCode1)
# 2 for accesCode2
codeUsage21 = CodeUsage.create!(access_code: educator3_DISC_accessCode2)
codeUsage22 = CodeUsage.create!(access_code: educator3_DISC_accessCode2)

# Create 5 Code Usages for educator3 - MBTI
# 4 for accesCode1
codeUsage23 = CodeUsage.create!(access_code: educator3_PMAI_accessCode1)
codeUsage24 = CodeUsage.create!(access_code: educator3_PMAI_accessCode1)
codeUsage25 = CodeUsage.create!(access_code: educator3_PMAI_accessCode1)
codeUsage26 = CodeUsage.create!(access_code: educator3_PMAI_accessCode1)
# 1 for accesCode2
codeUsage27 = CodeUsage.create!(access_code: educator3_PMAI_accessCode2)

# Create 3 billing records for educator 2
billing1 = BillingRecord.create!(bill_number: '20150302-2-1', billable: educator2, created_at: "2015-03-02 08:00:00")
billing2 = BillingRecord.create!(bill_number: '20150302-2-2', billable: educator2, created_at: "2015-03-02 12:00:00")
billing3 = BillingRecord.create!(bill_number: '20150512-2-1', billable: educator2, created_at: "2015-05-12 09:30:00")

# Create 2 billing records for educator 4
billing4 = BillingRecord.create!(bill_number: '20150227-4-1', billable: educator3, created_at: "2015-02-27 11:20:00")
billing5 = BillingRecord.create!(bill_number: '20150719-4-1', billable: educator3, created_at: "2015-07-19 15:40:00")

# Create 3 billing line items for eudcator 2
billingDetail1 = BillingLineItem.create!(billing_record: billing1, quantity: 10, test: MBTI)
billingDetail2 = BillingLineItem.create!(billing_record: billing2, quantity: 20, test: Holland)
billingDetail3 = BillingLineItem.create!(billing_record: billing3, quantity: 30, test: ONET)

# Create 5 billing line items for educator 4
billingDetail4 = BillingLineItem.create!(billing_record: billing4, quantity: 15, test: MBTI)
billingDetail5 = BillingLineItem.create!(billing_record: billing4, quantity: 25, test: Holland)
billingDetail6 = BillingLineItem.create!(billing_record: billing4, quantity: 35, test: ONET)
billingDetail7 = BillingLineItem.create!(billing_record: billing5, quantity: 40, test: DISC)
billingDetail8 = BillingLineItem.create!(billing_record: billing5, quantity: 50, test: PMAI)
