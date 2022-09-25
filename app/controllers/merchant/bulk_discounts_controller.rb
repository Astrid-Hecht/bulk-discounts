class Merchant::BulkDiscountsController < Merchant::BaseController
  before_action :set_bulk_discount, only: [:show]

  def index
    @bulk_discounts = @merchant.find_relevant_discounts
  end

  private
  def bulk_discount_params
    params.permit(:discount, :threshold)
  end

  def set_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end
end