require 'rails_helper'

RSpec.describe "merchant's bulk discounts index", type: :feature do
  describe 'As a merchant' do
    describe 'When I visit my bulk discounts index (/merchants/merchant_id/bulk_discounts)' do
      let!(:carly) { Merchant.create!(name: "Carly Simon's Candy Silo") }
      let!(:jewlery) { Merchant.create!(name: 'Jewlery City Merchant') }

      let!(:carly_bd_1) { carly.bulk_discounts.create!(discount: 20, threshold: 15) }
      let!(:carly_bd_2) { carly.bulk_discounts.create!(discount: 25, threshold: 30) }
      let!(:carly_bd_3) { carly.bulk_discounts.create!(discount: 30, threshold: 50) }

      let!(:jewlery_bd_1) { jewlery.bulk_discounts.create!(discount: 10, threshold: 15) }
      let!(:jewlery_bd_2) { jewlery.bulk_discounts.create!(discount: 50, threshold: 1500) }

      before(:each) do
        visit merchant_bulk_discounts_path(carly)
      end

      it 'I see the next three holidays and their dates' do
        within '#holidays' do
          expect(page).to have_selector(:css, '.holiday', count: 3)
          expect(page).to have_content('Name:', count: 3)
          expect(page).to have_content('Date:', count: 3)
        end
      end

      it 'Where I see all of my bulk discounts' do
        within '#discount-table' do
          expect(page).to have_selector(:css, '.discount', count: 3)
        end
      end

      it 'including their percentage discount and quantity thresholds' do
        within '#discount-table' do
          within "#bd-id-#{carly_bd_1.id}" do
            expect(page).to have_content("#{carly_bd_1.discount}%")
            expect(page).to have_content("#{carly_bd_1.threshold} items")
          end
          within "#bd-id-#{carly_bd_2.id}" do
            expect(page).to have_content("#{carly_bd_2.discount}%")
            expect(page).to have_content("#{carly_bd_2.threshold} items")
          end
          within "#bd-id-#{carly_bd_3.id}" do
            expect(page).to have_content("#{carly_bd_3.discount}%")
            expect(page).to have_content("#{carly_bd_3.threshold} items")
          end
        end
      end

      it 'And each bulk discount listed includes a link to its show page' do
        within '#discount-table' do
          within "#bd-id-#{carly_bd_1.id}" do
            click_link "#{carly_bd_1.id}"
          end
        end
        expect(current_path).to eq(merchant_bulk_discount_path(carly, carly_bd_1))
      end

      describe 'bulk discount delete' do
        it 'next to each bulk discount I see a link to delete it' do
          within '#discount-table' do
            within "#bd-id-#{carly_bd_1.id}" do
              expect(page).to have_link('Delete Discount')
            end
            within "#bd-id-#{carly_bd_2.id}" do
              expect(page).to have_link('Delete Discount')
            end
            within "#bd-id-#{carly_bd_3.id}" do
              expect(page).to have_link('Delete Discount')
            end
          end
        end

        it 'When I click this link Then I am redirected back to the bulk discounts index page And I no longer see the discount listed' do
          within '#discount-table' do
            expect(page).to have_content("#{carly_bd_1.discount}%")
            expect(page).to have_content("#{carly_bd_1.threshold} items")
            expect(page).to have_selector(:css, "#bd-id-#{carly_bd_1.id}", count: 1)

            within "#bd-id-#{carly_bd_1.id}" do
              click_link('Delete Discount')
            end
          end
          expect(current_path).to eq(merchant_bulk_discounts_path(carly))
          within '#discount-table' do
            expect(page).to_not have_selector(:css, "#bd-id-#{carly_bd_1.id}")
          end
        end
      end
    end
  end
end
