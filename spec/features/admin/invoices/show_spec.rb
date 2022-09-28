require 'rails_helper'

RSpec.describe 'admin invoice show', type: :feature do
  let!(:jewlery_city) { Merchant.create!(name: 'Jewlery City Merchant') }
  let!(:carly_silo) { Merchant.create!(name: "Carly Simon's Candy Silo") }

  let!(:gold_earrings) do
    jewlery_city.items.create!(name: 'Gold Earrings', description: "14k Gold 12' Hoops", unit_price: 12_000)
  end
  let!(:silver_necklace) do
    jewlery_city.items.create!(name: 'Silver Necklace', description: 'An everyday wearable silver necklace',
                               unit_price: 220_000)
  end
  # no one is buying the studded bracelet so it should not appear in the tests
  let!(:studded_bracelet) do
    jewlery_city.items.create!(name: 'Gold Studded Bracelet', description: 'A bracet to make others jealous',
                               unit_price: 2900)
  end
  let!(:licorice) do
    carly_silo.items.create!(name: 'Licorice Funnels', description: 'Licorice Balls', unit_price: 1200, enabled: true)
  end

  let!(:alaina) { Customer.create!(first_name: 'Alaina', last_name: 'Kneiling') }

  let!(:alaina_invoice1) { alaina.invoices.create!(status: 'completed') }
  let!(:alaina_invoice2) { alaina.invoices.create!(status: 'in_progress') }

  # alaina_invoice1 should have, from Jewelry, gold earrings and silver necklace, NOT studded bracelet. should also have licorice id, but that should not be shown for this merchant
  let!(:alainainvoice1_itemgold_earrings) do
    InvoiceItem.create!(invoice_id: alaina_invoice1.id, item_id: gold_earrings.id, quantity: 4, unit_price: 1300,
                        status: 'packaged')
  end
  let!(:alainainvoice9_itemgold_earrings) do
    InvoiceItem.create!(invoice_id: alaina_invoice1.id, item_id: gold_earrings.id, quantity: 6, unit_price: 1111,
                        status: 'shipped')
  end

  let!(:alainainvoice1_itemsilver_necklace) do
    InvoiceItem.create!(invoice_id: alaina_invoice1.id, item_id: silver_necklace.id, quantity: 7, unit_price: 1500,
                        status: 'packaged')
  end

  let!(:alainainvoice1_itemsilver_necklace2) do
    InvoiceItem.create!(invoice_id: alaina_invoice1.id, item_id: silver_necklace.id, quantity: 4, unit_price: 1300,
                        status: 'packaged')
  end

  let!(:alainainvoice1_itemslicorice) do
    InvoiceItem.create!(invoice_id: alaina_invoice1.id, item_id: licorice.id, quantity: 4, unit_price: 1300,
                        status: 'packaged')
  end

  # this invoice contains an item belonging to this merchant, but no info should be should on invoice1 show page
  let!(:alainainvoice2_itemstudded_bracelet) do
    InvoiceItem.create!(invoice_id: alaina_invoice2.id, item_id: studded_bracelet.id, quantity: 40, unit_price: 3678,
                        status: 'shipped')
  end

    before(:each) {visit admin_invoice_path(alaina_invoice1)}

    it 'shows all invoice info' do
        expect(page).to have_content("##{alaina_invoice1.id}")
        expect(page).to have_content("#{alaina_invoice1.status}")
        expect(page).to have_content("Created at: #{alaina_invoice1.created_at.strftime('%A, %B %d, %Y')}")
        expect(page).to have_content("#{alaina.name}")
        expect(page).to_not have_content("#{alaina_invoice2.id}")
        expect(page).to have_content(format('%.2f', alaina_invoice1.calculate_invoice_revenue / 100.to_f))
    end

    describe 'invoice items' do
        it 'shows all invoice items' do
        within '#invoice_items' do
            expect(page).to have_content(alainainvoice1_itemgold_earrings.item.name)
            expect(page).to have_content(alainainvoice1_itemsilver_necklace.item.name)
            expect(page).to_not have_content(alainainvoice2_itemstudded_bracelet.item.name)
        end
        end

        it 'shows all item info' do
            expect(page).to have_content(alainainvoice1_itemgold_earrings.item.name)
            expect(page).to have_content("#{alainainvoice1_itemgold_earrings.quantity}")
            expect(page).to have_content(format('%.2f', alainainvoice1_itemgold_earrings.unit_price / 100.to_f))
            expect(page).to have_content("#{alainainvoice1_itemgold_earrings.status}")
            expect(page).to_not have_content(format('%.2f', alainainvoice2_itemstudded_bracelet.unit_price / 100.to_f))
        end
    end

    it 'invoice status is a select field and can be updated' do
        expect(alaina_invoice1.status).to eq('completed')
        within('#invoice_info') do
            select 'in_progress', from: 'invoice_status'
            click_button('Update Invoice')
            alaina_invoice1.reload
            expect(alaina_invoice1.status).to eq('in_progress')
        end
    end

    describe 'BulkDiscount tests' do
        before(:each) do
            @bd1 = jewlery_city.bulk_discounts.create!(discount: 50, threshold: 5)
            visit admin_invoice_path(alaina_invoice1)
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
            within("#item_#{alainainvoice9_itemgold_earrings.id}") do
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

            visit admin_invoice_path(alaina_invoice1)

            within("#item_#{alainainvoice1_itemsilver_necklace.id}") do
                expect(page).to have_link('Applied Discount')

                click_link 'Applied Discount'
            end
            expect(current_path).to eq(merchant_bulk_discount_path(jewlery_city, bd2))
        end
    end
end
