require 'rails_helper'
RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
  end

  let!(:jewlery_city) { Merchant.create!(name: "Jewlery City Merchant")}
  let!(:carly_silo) { Merchant.create!(name: "Carly Simon's Candy Silo")}

  let!(:gold_earrings) { jewlery_city.items.create!(name: "Gold Earrings", description: "14k Gold 12' Hoops", unit_price: 12000) }
  let!(:silver_necklace) { jewlery_city.items.create!(name: "Silver Necklace", description: "An everyday wearable silver necklace", unit_price: 220000) }
  let!(:licorice) { carly_silo.items.create!(name: "Licorice Funnels", description: "Licorice Balls", unit_price: 1200, enabled: true) }

  let!(:alaina) { Customer.create!(first_name: "Alaina", last_name: "Kneiling")}

  let!(:alaina_invoice1) { alaina.invoices.create!(status: "completed")}

  let!(:alainainvoice1_itemgold_earrings) { InvoiceItem.create!(invoice_id: alaina_invoice1.id, item_id: gold_earrings.id, quantity: 4, unit_price: 1300, status:"packaged" )}
  let!(:alainainvoice1_itemgold_earrings2) { InvoiceItem.create!(invoice_id: alaina_invoice1.id, item_id: gold_earrings.id, quantity: 6, unit_price: 1111, status:"packaged" )}

  let!(:alainainvoice1_itemsilver_necklace) { InvoiceItem.create!(invoice_id: alaina_invoice1.id, item_id: silver_necklace.id, quantity: 7, unit_price: 1500, status:"packaged" )}

  let!(:alainainvoice1_itemglicorice) { InvoiceItem.create!(invoice_id: alaina_invoice1.id, item_id: licorice.id, quantity: 4, unit_price: 1300, status:"packaged" )}

  describe 'instance methods' do
    describe '#best_discount' do
      it 'returns best applicable bulk_discount, or nil if there are none' do
        bd1 = jewlery_city.bulk_discounts.create!(discount: 50, threshold: 5)

        expect(alainainvoice1_itemgold_earrings.best_discount).to eq(nil)
        expect(alainainvoice1_itemgold_earrings2.best_discount).to eq(bd1)
        expect(alainainvoice1_itemsilver_necklace.best_discount).to eq(bd1)

        bd2 = jewlery_city.bulk_discounts.create!(discount: 75, threshold: 7)

        expect(alainainvoice1_itemgold_earrings.best_discount).to eq(nil)
        expect(alainainvoice1_itemgold_earrings2.best_discount).to eq(bd1)
        expect(alainainvoice1_itemsilver_necklace.best_discount).to eq(bd2)

      end

      it 'returns nil if the discount and item dont match merchants' do
        bd1 = jewlery_city.bulk_discounts.create!(discount: 50, threshold: 1)
        expect(alainainvoice1_itemglicorice.best_discount).to eq(nil)
      end
    end
  end
end
