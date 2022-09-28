class Merchant::BulkDiscountsController < Merchant::BaseController
  before_action :set_bulk_discount, only: [:show, :edit]
  before_action :get_holidays, only: [:index]

  def index
    @bulk_discounts = @merchant.find_relevant_discounts
  end

  def destroy
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def create
    bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)
    if params[:discount] == '' || params[:threshold] == ''
      flash[:notice] = 'Both fields must have values. Please try again.'
      redirect_to new_merchant_bulk_discount_path(@merchant)
    elsif !params[:discount].to_i.positive? 
      flash[:notice] = 'Percent discount must be greater than zero. Please try again.'
      redirect_to new_merchant_bulk_discount_path(@merchant)
    elsif !params[:threshold].to_i.positive?
      flash[:notice] = 'Threshold must be greater than zero. Please try again.'
      redirect_to new_merchant_bulk_discount_path(@merchant)
    else
      bulk_discount.save(bulk_discount_params)
      flash[:notice] = 'Bulk discount has been successfully created.'
      redirect_to merchant_bulk_discounts_path(@merchant)
    end
  end

  def update
    @bulk_discount = BulkDiscount.find(params[:id])
    if params[:discount] == '' || params[:threshold] == ''
      flash[:notice] = 'Both fields must have values. Please try again.'
      redirect_to edit_merchant_bulk_discount_path(@merchant,@bulk_discount)
    elsif !params[:discount].to_i.positive? 
      flash[:notice] = 'Percent discount must be greater than zero. Please try again.'
      redirect_to edit_merchant_bulk_discount_path(@merchant,@bulk_discount)
    elsif !params[:threshold].to_i.positive?
      flash[:notice] = 'Threshold must be greater than zero. Please try again.'
      redirect_to edit_merchant_bulk_discount_path(@merchant,@bulk_discount)
    else
      @bulk_discount.update(bulk_discount_params)
      flash[:notice] = 'Bulk discount has been successfully updated.'
      redirect_to merchant_bulk_discount_path(@merchant,@bulk_discount)
    end
  end

  private
  def bulk_discount_params
    params.permit(:discount, :threshold)
  end

  def set_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def get_holidays
    @holidays = HolidayFacade.next_3
  end
end