require 'rails_helper'

RSpec.describe "merchant's bulk discount show page", type: :feature do
  describe 'As a merchant' do
    describe "When I visit one of my bulk discount's show page" do
      let!(:carly) { Merchant.create!(name: "Carly Simon's Candy Silo") }
      let!(:jewlery) { Merchant.create!(name: 'Jewlery City Merchant') }

      let!(:carly_bd_1) { carly.bulk_discounts.create!(discount: 20, threshold: 15) }
      let!(:carly_bd_2) { carly.bulk_discounts.create!(discount: 25, threshold: 30) }
      let!(:carly_bd_3) { carly.bulk_discounts.create!(discount: 30, threshold: 50) }

      let!(:jewlery_bd_1) { jewlery.bulk_discounts.create!(discount: 10, threshold: 15) }
      let!(:jewlery_bd_2) { jewlery.bulk_discounts.create!(discount: 50, threshold: 1500) }

      before(:each) do
        visit merchant_bulk_discount_path(carly, carly_bd_1)
      end

      it "Then I see the bulk discount's quantity threshold and percentage discount" do
        expect(page).to have_content("Percent Discount: #{carly_bd_1.discount}%")
        expect(page).to have_content("Quantity Threshold: #{carly_bd_1.threshold} items")
      end
    end
  end
end
