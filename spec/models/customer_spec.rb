require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'relationships' do
    it { should have_many(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end

  let!(:carly_silo) { Merchant.create!(name: "Carly Simon's Candy Silo")}
  let!(:jewlery_city) { Merchant.create!(name: "Jewlery City Merchant")}

  let!(:licorice) { carly_silo.items.create!(name: "Licorice Funnels", description: "Licorice Balls", unit_price: 1200) }
  let!(:peanut) { carly_silo.items.create!(name: "Peanut Bronzinos", description: "Peanut Caramel Chews", unit_price: 1500) }
  let!(:choco_waffle) { carly_silo.items.create!(name: "Chocolate Waffles Florentine", description: "Cholately Waffles of Deliciousness", unit_price: 900) }
  let!(:hummus) { carly_silo.items.create!(name: "Hummus", description: "Creamy Hummus", unit_price: 1200) }

  let!(:gold_earrings) { jewlery_city.items.create!(name: "Gold Earrings", description: "14k Gold 12' Hoops", unit_price: 12000) }
  let!(:silver_necklace) { jewlery_city.items.create!(name: "Silver Necklace", description: "An everyday wearable silver necklace", unit_price: 220000) }
  let!(:studded_bracelet) { jewlery_city.items.create!(name: "Gold Studded Bracelet", description: "A bracet to make others jealous", unit_price: 2900) }
  let!(:dainty_anklet) { jewlery_city.items.create!(name: "Dainty Ankley", description: "An everyday ankley", unit_price: 2299) }
  let!(:stackable_rings) { jewlery_city.items.create!(name: "Stackable Gold Rings", description: "Small rings to be mixed and matched", unit_price: 1299) }

  let!(:alaina) { Customer.create!(first_name: "Alaina", last_name: "Kneiling")}
  let!(:whitney) { Customer.create!(first_name: "Whitney", last_name: "Gains")}
  let!(:sydney) { Customer.create!(first_name: "Sydney", last_name: "Lang")}
  let!(:eddie) { Customer.create!(first_name: "Eddie", last_name: "Young")}
  let!(:ryan) { Customer.create!(first_name: "Ryan", last_name: "Vergeront")}
  let!(:leah) { Customer.create!(first_name: "Leah", last_name: "Anderson")}
  let!(:polina) { Customer.create!(first_name: "Polina", last_name: "Eisenberg")}

  let!(:whitney_invoice1) { whitney.invoices.create!(status: "completed")}
  let!(:whitney_invoice2) { whitney.invoices.create!(status: "completed")}
  let!(:whitney_invoice3) { whitney.invoices.create!(status: "completed")}
  let!(:whitney_invoice4) { whitney.invoices.create!(status: "completed")}
  let!(:whitney_invoice5) { whitney.invoices.create!(status: "completed")}
  let!(:whitney_invoice6) { whitney.invoices.create!(status: "completed")}
  let!(:alaina_invoice1) { alaina.invoices.create!(status: "completed")}
  let!(:alaina_invoice2) { alaina.invoices.create!(status: "in_progress")}
  let!(:alaina_invoice3) { alaina.invoices.create!(status: "completed")}
  let!(:alaina_invoice4) { alaina.invoices.create!(status: "completed")}
  let!(:alaina_invoice5) { alaina.invoices.create!(status: "completed")}
  let!(:eddie_invoice1) { eddie.invoices.create!(status: "completed")}
  let!(:eddie_invoice2) { eddie.invoices.create!(status: "completed")}
  let!(:eddie_invoice3) { eddie.invoices.create!(status: "completed")}
  let!(:ryan_invoice1) { ryan.invoices.create!(status: "completed")}
  let!(:ryan_invoice2) { ryan.invoices.create!(status: "completed")}
  let!(:polina_invoice1) { polina.invoices.create!(status: "completed")}
  let!(:polina_invoice2) { polina.invoices.create!(status: "cancelled")}
  let!(:leah_invoice1) { leah.invoices.create!(status: "cancelled")}
  let!(:leah_invoice2) { leah.invoices.create!(status: "in_progress")}

  let!(:whitney_invoice1_transaction) { whitney_invoice1.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:whitney_invoice2_transaction) { whitney_invoice2.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:whitney_invoice3_transaction) { whitney_invoice3.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:whitney_invoice4_transaction) { whitney_invoice4.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:whitney_invoice5_transaction) { whitney_invoice5.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:whitney_invoice6_transaction) { whitney_invoice6.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:alaina_invoice1_transaction) { alaina_invoice1.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:alaina_invoice2_transaction) { alaina_invoice2.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:alaina_invoice3_transaction) { alaina_invoice3.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:alaina_invoice4_transaction) { alaina_invoice4.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:alaina_invoice5_transaction) { alaina_invoice5.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:eddie_invoice1_transaction) { eddie_invoice1.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:eddie_invoice2_transaction) { eddie_invoice2.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:eddie_invoice3_transaction) { eddie_invoice3.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:polina_invoice1_transaction) { polina_invoice1.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:polina_invoice2_transaction) { polina_invoice2.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:ryan_invoice1_transaction) { ryan_invoice1.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:ryan_invoice2_transaction) { ryan_invoice2.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")}
  let!(:leah_invoice1_transaction) { leah_invoice1.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "failed")}
  let!(:leah_invoice2_transaction) { leah_invoice1.transactions.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "failed")}

  let!(:alainainvoice1_itemgold_earrings) { InvoiceItem.create!(invoice_id: alaina_invoice1.id, item_id: gold_earrings.id, quantity: 4, unit_price: 1300, status:"packaged" )}
  let!(:alainainvoice2_itemgold_earrings) { InvoiceItem.create!(invoice_id: alaina_invoice2.id, item_id: gold_earrings.id, quantity: 40, unit_price: 1500, status:"shipped" )}
  let!(:alainainvoice3_itemgold_earrings) { InvoiceItem.create!(invoice_id: alaina_invoice3.id, item_id: gold_earrings.id, quantity: 12, unit_price: 1600, status:"shipped" )}
  let!(:alainainvoice4_itemgold_earrings) { InvoiceItem.create!(invoice_id: alaina_invoice4.id, item_id: gold_earrings.id, quantity: 4, unit_price: 2400, status:"shipped" )}
  let!(:alainainvoice5_itemgold_earrings) { InvoiceItem.create!(invoice_id: alaina_invoice5.id, item_id: gold_earrings.id, quantity: 243, unit_price: 27000, status:"shipped" )}

  let!(:whitneyinvoice1_itemsilver_necklace) { InvoiceItem.create!(invoice_id: whitney_invoice1.id, item_id: silver_necklace.id, quantity: 3, unit_price: 270, status:"shipped" )}
  let!(:whitneyinvoice2_itemsilver_necklace) { InvoiceItem.create!(invoice_id: whitney_invoice2.id, item_id: silver_necklace.id, quantity: 31, unit_price: 270, status:"shipped" )}
  let!(:whitneyinvoice3_itemsilver_necklace) { InvoiceItem.create!(invoice_id: whitney_invoice3.id, item_id: silver_necklace.id, quantity: 1, unit_price: 270, status:"shipped" )}
  let!(:whitneyinvoice4_itemsilver_necklace) { InvoiceItem.create!(invoice_id: whitney_invoice4.id, item_id: silver_necklace.id, quantity: 10, unit_price: 270, status:"shipped" )}
  let!(:whitneyinvoice5_itemsilver_necklace) { InvoiceItem.create!(invoice_id: whitney_invoice5.id, item_id: silver_necklace.id, quantity: 1, unit_price: 270, status:"shipped" )}
  let!(:whitneyinvoice6_itemsilver_necklace) { InvoiceItem.create!(invoice_id: whitney_invoice6.id, item_id: silver_necklace.id, quantity: 3, unit_price: 270, status:"shipped" )}


  let!(:eddie_invoice1_itemstudded_bracelet) { InvoiceItem.create!(invoice_id: eddie_invoice1.id, item_id: studded_bracelet.id, quantity: 3, unit_price: 2199, status:"shipped" )}
  let!(:eddie_invoice2_itemstudded_bracelet) { InvoiceItem.create!(invoice_id: eddie_invoice2.id, item_id: studded_bracelet.id, quantity: 3, unit_price: 2700, status:"shipped" )}
  let!(:eddie_invoice3_itemstudded_bracelet) { InvoiceItem.create!(invoice_id: eddie_invoice3.id, item_id: studded_bracelet.id, quantity: 3, unit_price: 10299, status:"shipped" )}

  let!(:polina_invoice1_itemstudded_bracelet) { InvoiceItem.create!(invoice_id: polina_invoice1.id, item_id: dainty_anklet.id, quantity: 6, unit_price: 270, status:"shipped" )}
  let!(:polina_invoice2_itemstudded_bracelet) { InvoiceItem.create!(invoice_id: polina_invoice2.id, item_id: dainty_anklet.id, quantity: 1, unit_price: 270, status:"shipped" )}

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
       #method goes here
      end
    end

    describe '#top_five_buyers' do
      let!(:top_5) {Customer.top_5_customers}
      it 'returns 5 customers' do
        expect(top_5.to_a.count).to eq(5)
      end

      it 'returns names' do
        expect(top_5[0].name).to eq(whitney.name)
        expect(top_5[1].name).to eq(alaina.name)
        expect(top_5[2].name).to eq(eddie.name)
        expect(top_5[3].name).to eq(ryan.name)
        expect(top_5[4].name).to eq(polina.name)
      end

      it 'returns successful transaction count' do
        expect(top_5[0].num_succesful_transactions).to eq(6)
        expect(top_5[1].num_succesful_transactions).to eq(5)
        expect(top_5[2].num_succesful_transactions).to eq(3)
        expect(top_5[3].num_succesful_transactions).to eq(2)
        expect(top_5[4].num_succesful_transactions).to eq(2)
      end

      it 'sorts by first added if two customers tie' do
        expect(top_5[3].name).to eq(ryan.name)
        expect(top_5[4].name).to eq(polina.name)
        expect(top_5.map(&:name).include?(leah.name)).to be(false)
      end
    end
  end

  describe 'instance methods' do
    describe '#number_of_purchases' do
      it 'can find the number of successful purchases a customer has' do
        expect(alaina.num_succesful_transactions).to eq(5)
        expect(eddie.num_succesful_transactions).to eq(3)
        #expect statement here
      end
    end

    describe '#name' do
      it 'returns the combined first and last names of the customer' do
        expect(whitney.name).to eq("Whitney Gains")
        expect(alaina.name).to eq("Alaina Kneiling")
        expect(eddie.name).to eq("Eddie Young")
        expect(leah.name).to eq("Leah Anderson")
        expect(polina.name).to eq("Polina Eisenberg")
      end
    end
  end
end