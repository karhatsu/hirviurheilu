class RelayCorrectEstimate < ActiveRecord::Base
  belongs_to :relay

  validates :distance, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 50, :less_than_or_equal_to => 200 }
end
