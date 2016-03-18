class Shot < ActiveRecord::Base
  belongs_to :competitor, touch: true

  validates :value, :allow_nil => true, :numericality => { :only_integer => true,
      :greater_than_or_equal_to => 0, :less_than_or_equal_to => 10 }

  after_save :set_competitor_has_result

  private

  def set_competitor_has_result
    unless competitor.has_result?
      competitor.has_result = true
      competitor.save
    end
  end
end
