class Invoice < ApplicationRecord
  enum status: [:cancelled, :completed, :in_progress]
  
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  def self.incomplete_invoices
    where("status = 2").order(:created_at)
  end

  def merchant_items(merchant)
    items.where(items: { merchant_id: merchant.id }).left_joins(:invoice_items).distinct
  end

  def calculate_invoice_revenue
    invoice_items.sum("quantity*unit_price")
  end

  def merchant_invoice_revenue(merchant)
    items.where(items: { merchant_id: merchant.id }).merge(invoice_items).sum("invoice_items.quantity*invoice_items.unit_price")
  end

  
end
