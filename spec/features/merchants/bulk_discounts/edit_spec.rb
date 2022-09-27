require 'rails_helper'

RSpec.describe "merchant's bulk discount edit page", type: :feature do
  describe 'As a merchant' do
    describe "When I visit my bulk discount's edit page" do
      let!(:carly) { Merchant.create!(name: "Carly Simon's Candy Silo") }
      let!(:carly_bd_1) { carly.bulk_discounts.create!(discount: 20, threshold: 15) }

      describe "When I visit my bulk discount's show page" do
        it 'Then I see a link to edit the discount, click it and I am taken to a new page ' do
          visit merchant_bulk_discount_path(carly, carly_bd_1)
          expect(page).to have_link("Edit Bulk Discount")
          click_link "Edit Bulk Discount"
          expect(current_path).to eq(edit_merchant_bulk_discount_path(carly, carly_bd_1))
        end
      end

      before(:each) do
        visit edit_merchant_bulk_discount_path(carly, carly_bd_1)
      end

      it "where I see a form to edit the bulk discount And I see that the discounts current attributes are pre-poluated" do
        expect(page).to have_field("Percent Discount:", with: '20')
        expect(page).to have_field("Quantity Threshold:", with: '15')
        expect(page).to have_button("Update")
      end

      it "When I change any of the information & submit, I'm redirected to BD show And I see my edited bulk discount listed" do
        visit merchant_bulk_discount_path(carly, carly_bd_1)

        expect(page).to have_content("Percent Discount: 20%")
        expect(page).to have_content("Quantity Threshold: 15 items")
        
        click_link "Edit Bulk Discount"

        fill_in "Percent Discount:", with: '25'
        fill_in "Quantity Threshold:", with: '25'
        click_button "Update"

        expect(page).to have_content('Bulk discount has been successfully updated.')

        expect(current_path).to eq(merchant_bulk_discount_path(carly, carly_bd_1))
        expect(page).to have_content("Percent Discount: 25%")
        expect(page).to have_content("Quantity Threshold: 25 items")

      end

      it "flashes a warning & doesnt submit if discount is not positive int" do
        fill_in "Percent Discount:", with: '0'
        fill_in "Quantity Threshold:", with: '25'
        click_button "Update"
        expect(current_path).to eq(edit_merchant_bulk_discount_path(carly, carly_bd_1))
        expect(page).to have_content("Percent discount must be greater than zero. Please try again.")
      end

      it "flashes a warning & doesnt submit if threshold is not positive int" do
        fill_in "Percent Discount:", with: '34'
        fill_in "Quantity Threshold:", with: '0'
        click_button "Update"

        expect(current_path).to eq(edit_merchant_bulk_discount_path(carly, carly_bd_1))
        expect(page).to have_content("Threshold must be greater than zero. Please try again.")
      end
      it "flashes a warning & doesnt submit if a field is empty" do
        fill_in "Percent Discount:", with: ''
        fill_in "Quantity Threshold:", with: ''
        click_button "Update"

        expect(current_path).to eq(edit_merchant_bulk_discount_path(carly, carly_bd_1))
        expect(page).to have_content("Both fields must have values. Please try again.")
      end
    end
  end
end
