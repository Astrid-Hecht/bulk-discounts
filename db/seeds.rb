# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#  Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

merc1 = Merchant.find(1)
merc2 = Merchant.find(2)

merc1.bulk_discounts.create!(discount: 20, threshold: 15)
merc1.bulk_discounts.create!(discount: 25, threshold: 30)
merc1.bulk_discounts.create!(discount: 30, threshold: 50)

merc2.bulk_discounts.create!(discount: 10, threshold: 15)
merc2.bulk_discounts.create!(discount: 50, threshold: 1500)