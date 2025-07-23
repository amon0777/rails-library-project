class Statistic < ApplicationRecord
  belongs_to :service_area
  
  validates :active_users, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :population, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :municipality, length: { maximum: 255 }, allow_blank: true
  validates :bilingual, inclusion: { in: [true, false] }
  validates :northern, inclusion: { in: [true, false] }

  def calculated_percentage
    return 0.0 if population.nil? || population.zero?
    (active_users.to_f / population.to_f * 100).round(2)
  end 
  
  def self.ransackable_attributes(auth_object = nil)
    ["active_users", "population", "month", "percentage", "municipality", "bilingual", "northern", "created_at", "updated_at"]
  end
  
 
  def self.ransackable_associations(auth_object = nil)
    ["service_area"]
  end
end