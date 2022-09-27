class Merchant::BulkDiscountsController < Merchant::BaseController
  before_action :set_bulk_discount, only: [:show]

  def index
    @bulk_discounts = @merchant.find_relevant_discounts
  end

  def destroy
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def create
    bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)
    bulk_discount.save
    flash.notice = "New Discount (ID: #{bulk_discount.id} Created for #{@merchant.name}"
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private
  def bulk_discount_params
    params.permit(:discount, :threshold)
  end

  def set_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end
end