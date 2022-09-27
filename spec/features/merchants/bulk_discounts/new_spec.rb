require 'rails_helper'

RSpec.describe "merchant's bulk discount create page", type: :feature do
  describe 'As a merchant' do
    describe "When I visit my bulk discount's create page" do
      let!(:carly) { Merchant.create!(name: "Carly Simon's Candy Silo") }
      
      describe "When I visit my bulk discount's index page" do
        it 'Then I see a link to create a new discount, click it and I am taken to a new page ' do
          visit merchant_bulk_discounts_path(carly)
          expect(page).to have_link("Create New Bulk Discount")
          click_link "Create New Bulk Discount"
          expect(current_path).to eq(new_merchant_bulk_discount_path(carly))
        end
      end

      before(:each) do
        visit new_merchant_bulk_discount_path(carly)
      end

      it "where I see a form to add a new bulk discount" do
        expect(page).to have_field("Percent Discount:")
        expect(page).to have_field("Quantity Threshold:")
        expect(page).to have_button("Create")
      end

      it "When I fill in the form with valid data & submit, I'm redirected back to BD index And I see my new bulk discount listed" do
        visit merchant_bulk_discounts_path(carly)
        expect(page).to_not have_selector(:css, '.discount')

        click_link "Create New Bulk Discount"

        fill_in "Percent Discount:", with: 20
        fill_in "Quantity Threshold:", with: 25
        click_button "Create"

        expect(page).to have_content("Bulk discount has been successfully created.")
        expect(page).to have_selector(:css, '.discount', count: 1)

        within '#discount-table' do
          expect(page).to have_content("20%")
          expect(page).to have_content("25 items")
        end
      end

      it "flashes a warning & doesnt submit if discount is not positive int" do
        fill_in "Percent Discount:", with: '0'
        fill_in "Quantity Threshold:", with: '25'
        click_button "Create"
        expect(current_path).to eq(new_merchant_bulk_discount_path(carly))
        expect(page).to have_content("Percent discount must be greater than zero. Please try again.")
      end

      it "flashes a warning & doesnt submit if threshold is not positive int" do
        fill_in "Percent Discount:", with: '25'
        fill_in "Quantity Threshold:", with: '0'
        click_button "Create"

        expect(current_path).to eq(new_merchant_bulk_discount_path(carly))
        expect(page).to have_content("Threshold must be greater than zero. Please try again.")
      end
      
      it "flashes a warning & doesnt submit if a field is empty" do
        fill_in "Percent Discount:", with: ''
        fill_in "Quantity Threshold:", with: '45'
        click_button "Create"

        expect(current_path).to eq(new_merchant_bulk_discount_path(carly))
        expect(page).to have_content("Both fields must have values. Please try again.")
      end
    end
  end
end
