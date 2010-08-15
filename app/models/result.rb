class Result < ActiveRecord::Base
  belongs_to :competitor

  validates :shots_total_input, :allow_nil => true,
    :numericality => { :only_integer => true,
      :greater_than => -1, :less_than => 101 }
  validates :estimate1, :allow_nil => true,
    :numericality => { :only_integer => true, :greater_than => -1 }
  validates :estimate2, :allow_nil => true,
    :numericality => { :only_integer => true, :greater_than => -1 }
  validate :arrival_not_before_start_time

  protected
  def arrival_not_before_start_time
    return if competitor.start_time.nil?
    errors.add(:arrival, :arrival_not_before_start_time) if competitor.start_time > arrival
  end
    
end
