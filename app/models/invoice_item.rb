class InvoiceItem < ApplicationRecord
  enum status: [ :pending, :packaged, :shipped ]
  belongs_to :invoice
  belongs_to :item
  has_many :bulk_discounts, through: :item

  def best_discount
    bulk_discounts.joins(:invoice_items).select("invoice_items.quantity, bulk_discounts.*")
    .where("bulk_discounts.threshold <= ?", quantity).order(discount: :desc).first
  end
end