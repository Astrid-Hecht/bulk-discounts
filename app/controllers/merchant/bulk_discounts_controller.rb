class Merchant::BulkDiscountsController < Merchant::BaseController
  before_action :set_bulk_discount, only: [:show, :edit]

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

  def update
    @bulk_discount = BulkDiscount.find(params[:id])
    if params[:discount] && params[:discount].gsub('0', '') == ""
      flash[:notice] = 'Zero percent discount not permitted. Please try again.'
      redirect_to edit_merchant_bulk_discount_path(@merchant,@bulk_discount)
    elsif params[:discount] && params[:threshold]
      @bulk_discount.update(bulk_discount_params)
      flash[:notice] = 'Bulk discount has been successfully updated.'
      redirect_to merchant_bulk_discount_path(@merchant,@bulk_discount)
    else
      flash[:notice] = 'Both fields must have values. Please try again.'
      redirect_to edit_merchant_bulk_discount_path(@merchant,@bulk_discount)
    end
  end

  private
  def bulk_discount_params
    params.permit(:discount, :threshold)
  end

  def set_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end
end