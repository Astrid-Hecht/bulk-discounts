class Invoice < ApplicationRecord
  enum status: [:cancelled, :completed, :in_progress]
  
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  def self.incomplete_invoices
    where("status = 2").order(:created_at)
  end

  # def merchant_items(merchant)
  #   items.where(items: { merchant_id: merchant.id }).joins(:invoice_items).distinct
  # end

  def calculate_invoice_revenue
    invoice_items.sum("quantity*unit_price")
  end

  def merchant_invoice_revenue(merchant)
    items.where(items: { merchant_id: merchant.id }).merge(invoice_items).sum("invoice_items.quantity*invoice_items.unit_price")
  end

  def invoice_discount
    invoice_items.joins(:bulk_discounts)
      .select("invoice_items.id, max(invoice_items.unit_price * invoice_items.quantity * (bulk_discounts.discount)/100) as merchant_discount")
      .where("invoice_items.quantity >= bulk_discounts.threshold")
      .group("invoice_items.id")
      .order('merchant_discount DESC')
      .sum(&:'merchant_discount')
  end

  def discount_invoice_revenue
    calculate_invoice_revenue - invoice_discount
  end
end

# items.where(items: { merchant_id: merchant.id })
# .merge(