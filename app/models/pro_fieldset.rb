class ProFieldset < ActiveRecord::Base
  belongs_to :observation
  validates_presence_of :observation_id
end
