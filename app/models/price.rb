class Price < ActiveRecord::Base
  default_scope :order => 'min_competitors'

  validates :min_competitors, :numericality => { :only_integer => true,
    :greater_than => 0 }
  validates :price, :numericality => { :greater_than => 0 }

  def max_competitors
    Price.all.each do |p|
      if min_competitors < p.min_competitors
        return p.min_competitors - 1
      end
    end
    return nil
  end

  def self.price_for_competitor_amount(amount)
    price = 0
    all.each do |p|
      if amount >= p.min_competitors
        price = amount * p.price
      end
    end
    return price
  end
end
