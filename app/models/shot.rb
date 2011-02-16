class Shot < ActiveRecord::Base
  belongs_to :competitor

  #validates :competitor, :presence => true
  validates :value, :allow_nil => true, :numericality => { :only_integer => true,
      :greater_than_or_equal_to => 0, :less_than_or_equal_to => 10 }
end
