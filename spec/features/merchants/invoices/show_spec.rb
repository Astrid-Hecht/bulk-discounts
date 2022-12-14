require 'rails_helper'

RSpec.describe 'Merchant Index Show Page', type: :feature do

  # test data collapsed here
  let!(:jewlery_city) { Merchant.create!(name: "Jewlery City Merchant")}
  let!(:carly_silo) { Merchant.create!(name: "Carly Simon's Candy Silo")}

  let!(:gold_earrings) { jewlery_city.items.create!(name: "Gold Earrings", description: "14k Gold 12' Hoops", unit_price: 12000) }
  let!(:silver_necklace) { jewlery_city.items.create!(name: "Silver Necklace", description: "An everyday wearable silver necklace", unit_price: 220000) }
  let!(:studded_bracelet) { jewlery_city.items.create!(name: "Gold Studded Bracelet", description: "A bracet to make others jealous", unit_price: 2900) } #no one is buying the studded bracelet so it should not appear in the tests
  let!(:licorice) { carly_silo.items.create!(name: "Licorice Funnels", description: "Licorice Balls", unit_price: 1200, enabled: true) }

  let!(:alaina) { Customer.create!(first_name: "Alaina", last_name: "Kneiling")}

  let!(:alaina_invoice1) { alaina.invoices.create!(status: "completed")}
  let!(:alaina_invoice2) { alaina.invoices.create!(status: "in_progress")}

# alaina_invoice1 should have, from Jewelry, gold earrings and silver necklace, NOT studded bracelet. should also have licorice id, but that should not be shown for this merchant
  let!(:alainainvoice1_itemgold_earrings) { InvoiceItem.create!(invoice_id: alaina_invoice1.id, item_id: gold_earrings.id, quantity: 4, unit_price: 1300, status:"packaged" )}
  let!(:alainainvoice1_itemgold_earrings2) { InvoiceItem.create!(invoice_id: alaina_invoice1.id, item_id: gold_earrings.id, quantity: 6, unit_price: 1111, status:"packaged" )}

  let!(:alainainvoice1_itemsilver_necklace) { InvoiceItem.create!(invoice_id: alaina_invoice1.id, item_id: silver_necklace.id, quantity: 7, unit_price: 1500, status:"packaged" )}

  let!(:alainainvoice1_itemsilver_necklace2) { InvoiceItem.create!(invoice_id: alaina_invoice1.id, item_id: silver_necklace.id, quantity: 4, unit_price: 1300, status:"packaged" )}

  let!(:alainainvoice1_itemglicorice) { InvoiceItem.create!(invoice_id: alaina_invoice1.id, item_id: licorice.id, quantity: 4, unit_price: 1300, status:"packaged" )}

  #this invoice contains an item belonging to this merchant, but no info should be should on invoice1 show page
  let!(:alainainvoice2_itemstudded_bracelet) { InvoiceItem.create!(invoice_id: alaina_invoice2.id, item_id: studded_bracelet.id, quantity: 40, unit_price: 1500, status:"shipped" )}
  
  before(:each) {visit merchant_invoice_path(jewlery_city, alaina_invoice1)}

  describe 'when I visit a merchant invoice show page' do
    describe 'I see information related to the invoice' do
      it 'displays id number, status, date of creation, customer full name' do

        expect(page).to have_content("Invoice ##{alaina_invoice1.id}")
        expect(page).to have_content("Status: #{alaina_invoice1.status}")
        expect(page).to have_content("Created at: #{alaina_invoice1.created_at.strftime("%A, %B %d, %Y")}")
        expect(page).to have_content("#{alaina.name}")
      end
    end

    describe 'I see all of MY items on the invoice' do

      it 'displays the name of each merchant item on the invoice' do
        within("#invoice_items") do
          expect(page).to have_content(silver_necklace.name)
          expect(page).to have_content(gold_earrings.name)
        end
        expect(page).to have_content("Invoice ##{alaina_invoice1.id}")

        within("#invoice_items") do
          expect(page).to have_content(gold_earrings.name)
          expect(page).to have_content(silver_necklace.name)
          #checks we are not displaying items from a different invoice
          expect(page).to_not have_content(studded_bracelet.name)
          #checks we are not displaying items on this invoice from another merchant
          expect(page).to_not have_content(licorice.name)
        end
      end

      it 'displays the quantity, sale price, and status for each item' do
        within("#item_#{alainainvoice1_itemgold_earrings.id}") do
          expect(page).to have_content("#{alainainvoice1_itemgold_earrings.quantity}")
          expect(page).to have_content("#{((alainainvoice1_itemgold_earrings.unit_price)/100.to_f).round(2)}")
          expect(page).to have_field("Status", with: alainainvoice1_itemgold_earrings.status)
        end

        within("#item_#{alainainvoice1_itemsilver_necklace.id}") do
          expect(page).to have_content("#{alainainvoice1_itemsilver_necklace.quantity}")
          expect(page).to have_content("#{((alainainvoice1_itemsilver_necklace.unit_price)/100.to_f).round(2)}")
          expect(page).to have_field("Status", with: alainainvoice1_itemsilver_necklace.status)
        end
      end
      
      describe 'when I change an items status and click the submit button' do
        it 'takes me back to the merchant invoice show page and shows the updated status' do
          within("#item_#{alainainvoice1_itemgold_earrings.id}") do
            expect(page).to have_field("Status", with: "packaged")
            select "shipped", from: :status
            click_on "Update Item Status"
          end

          expect(current_path).to eq merchant_invoice_path(jewlery_city, alaina_invoice1)

          within("#item_#{alainainvoice1_itemgold_earrings.id}") do
            expect(page).to have_field("Status", with: "shipped")
          end
        end
      end

      it 'Then I see the total revenue that will be generated from all of my items on the invoice' do
        within("#total_invoice_revenue") do
          expect(page).to have_content("Total Revenue From This Invoice: $#{sprintf("%.2f",alaina_invoice1.calculate_invoice_revenue/100.to_f)}")
        end
      end

      it 'Then I see the total revenue that will be generated from all of my items on the invoice' do
        within("#merchant_invoice_revenue") do
          expect(page).to have_content("Your Revenue From This Invoice: $#{sprintf("%.2f",alaina_invoice1.merchant_invoice_revenue(jewlery_city)/100.to_f)}")
        end
      end

      describe 'Bulk Discount Revenue' do
        before(:each) do
          @bd1 = jewlery_city.bulk_discounts.create!(discount: 50, threshold: 5)
          visit merchant_invoice_path(jewlery_city, alaina_invoice1)
        end

        it 'And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation' do
          within("#discount_invoice_revenue") do
            expect(page).to have_content("Total Revenue With Discounts From This Invoice: $#{sprintf("%.2f",alaina_invoice1.discount_invoice_revenue/100.to_f)}")
          end
        end

        it 'Next to each invoice item I see a link to the show page for the bulk discount that was applied (if any)' do
          within("#item_#{alainainvoice1_itemgold_earrings.id}") do
            expect(page).to_not have_link('Applied Discount')
          end
          within("#item_#{alainainvoice1_itemgold_earrings2.id}") do
            expect(page).to have_link('Applied Discount')
            click_link 'Applied Discount'
          end
          expect(current_path).to eq(merchant_bulk_discount_path(jewlery_city, @bd1))
        end

        it 'links to the best possible discount' do 
          within("#item_#{alainainvoice1_itemsilver_necklace.id}") do
            expect(page).to have_link('Applied Discount')
            click_link 'Applied Discount'
          end
          expect(current_path).to eq(merchant_bulk_discount_path(jewlery_city, @bd1))

          bd2 = jewlery_city.bulk_discounts.create!(discount: 75, threshold: 7)

          visit merchant_invoice_path(jewlery_city, alaina_invoice1)

          within("#item_#{alainainvoice1_itemsilver_necklace.id}") do
            expect(page).to have_link('Applied Discount')
            click_link 'Applied Discount'
          end
          expect(current_path).to eq(merchant_bulk_discount_path(jewlery_city, bd2))
        end
      end
    end
  end
end


