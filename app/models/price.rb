class Price < ActiveRecord::Base
  validates :min_competitors, :numericality => { :only_integer => true,
    :greater_than => 0 }
  validates :price, :numericality => { :greater_than_or_equal_to => 0 }
  
  default_scope { order :min_competitors }

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
    Price.all.each do |p|
      if amount >= p.min_competitors
        price = amount * p.price
      end
    end
    return BasePrice.first.price + price
  end
end
