class Merchant < ApplicationRecord
  validates :name, presence: true
  validates :enabled, inclusion: [true, false]

  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  has_many :bulk_discounts, dependent: :destroy

  def self.enabled_merchants
    where('enabled = ?', true)
  end

  def self.disabled_merchants
    where('enabled = ?', false)
  end

  def self.merchants_top_5
    Merchant.joins(:items)
            .merge(Item.joins(:invoices)
                       .merge(Invoice.joins(:transactions)
                                     .where(transactions: { result: 1 })))
            .group(:id, :name)
            .select(:name, :id, 'sum(invoice_items.unit_price*quantity) as revenue')
            .order(revenue: :desc).limit(5)
  end

  def best_sales_date
    Merchant.joins(:items)
            .where('merchant_id = ?', self.id)
            .merge(Item.joins(:invoices)
                       .merge(Invoice.joins(:transactions)
                                     .where(transactions: { result: 1 } )))
            .select('invoices.created_at', "invoice_items.unit_price*quantity as revenue")
            .order("revenue desc", "invoices.created_at desc")
            .first
            .created_at
            .strftime("%B %d, %Y")
  end

  def fav_customers
    transactions.joins(invoice: :customer)
                .where('result = ?', 1)
                .where("invoices.status = ?", 1)
                .select("customers.*, count('transactions.result') as top_result")
                .group('customers.id')
                .order(top_result: :desc)
                .distinct
                .limit(5)
  end

  def ready_to_ship_items_ordered
    Invoice.select("items.*, invoices.created_at as creation_time, invoices.id as invoice_id")
           .joins(:items)
           .where(items: { merchant_id: self.id})
           .where.not(invoice_items: { status: 2 })
           .order(:created_at)
  end

  def enabled_items
    items.where(enabled: true)
  end

  def disabled_items
    items.where(enabled: false)
  end

  def top_5_items
    Item.joins(invoices: :transactions)
        .group(:id, :name)
        .where( transactions: {result: 1}, merchant_id: self.id)
        .select(:name, :id, "sum(invoice_items.unit_price*quantity) as revenue")
        .order(revenue: :desc)
        .limit(5)
  end

  def find_relevant_invoices
    Invoice.joins(:items).where(invoice_items: {item_id: self.items.pluck(:id)}).distinct
  end

  def find_relevant_discounts
    BulkDiscount.where(bulk_discounts: { merchant_id: id })
  end

end
