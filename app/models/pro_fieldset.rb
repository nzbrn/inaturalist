class ProFieldset < ActiveRecord::Base
  belongs_to :observation
  validates_numericality_of :density, :greater_than_or_equal_to => 0, :allow_blank => true
  validates_numericality_of :cover,:less_than_or_equal_to => 100, :greater_than_or_equal_to => 0, :allow_blank => true
end
