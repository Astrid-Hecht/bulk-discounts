require 'rails_helper'

RSpec.describe "merchant's bulk discounts index", type: :feature do
  describe 'As a merchant' do
    describe "When I visit my bulk discounts index (/merchants/merchant_id/bulk_discounts)" do
      let!(:carly) { Merchant.create!(name: "Carly Simon's Candy Silo")}
      let!(:jewlery) { Merchant.create!(name: "Jewlery City Merchant")}

      let!(:carly_bd_1) {carly.discounts.create!(discount: 20, threshold: 15)}
      let!(:carly_bd_2) {carly.discounts.create!(discount: 25, threshold: 30)}
      let!(:carly_bd_3) {carly.discounts.create!(discount: 30, threshold: 50)}

      let!(:jewlery_bd_1) {jewlery.discounts.create!(discount: 10, threshold: 15)}
      let!(:jewlery_bd_1) {jewlery.discounts.create!(discount: 50, threshold: 1500)}

      before(:each) do
        visit merchant_bulk_discounts_path(carly)
      end
    
      it 'Where I see all of my bulk discounts' do
        within '#discount-table' do
          expect(page).to have_selector(:css, '.discount', count: 3)
        end
      end

      it 'including their percentage discount and quantity thresholds' do 
        within '#discount-table' do
          within "#bd-id-#{carly_bd_1.id}" do
            expect(page).to have_content("#{carly-bd-1.discount}%")
            expect(page).to have_content("#{carly-bd-1.threshold} items")
          end
          within "#bd-id-#{carly_bd_2.id}" do
            expect(page).to have_content("#{carly-bd-2.discount}%")
            expect(page).to have_content("#{carly-bd-2.threshold} items")
          end
          within "#bd-id-#{carly_bd_3.id}" do
            expect(page).to have_content("#{carly-bd-3.discount}%")
            expect(page).to have_content("#{carly-bd-3.threshold} items")
          end
        end
      end

      it 'And each bulk discount listed includes a link to its show page' do 
        within '#discount-table' do 
          within "#bd-id-#{carly_bd_1.id}" do
            click_link 'Show'
          end
        end
        expect(current_path).to eq(merchant_bulk_discount_path(carly, carly_bd_1))
      end
    end
  end
end
