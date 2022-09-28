class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true
  
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :bulk_discounts, through: :merchant

  def best_sales_date
    date = self.invoices.select(:created_at, "invoice_items.unit_price*quantity as revenue").order("revenue desc", "invoices.created_at desc").first.created_at
    date.strftime("%B %d, %Y")
  end
end