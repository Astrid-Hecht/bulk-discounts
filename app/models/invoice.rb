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
    self.items.where(items: { merchant_id: merchant.id }).distinct
  end

  def calculate_invoice_revenue
    self.invoice_items.sum("quantity*unit_price")
  end

  def merchant_invoice_revenue(merchant)
    merchant_items(merchant).joins(:invoice_items).pluck(Arel.sql("SUM(invoice_items.quantity*invoice_items.unit_price)")).first
  end
end
