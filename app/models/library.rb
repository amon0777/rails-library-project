class Library < ApplicationRecord
  has_many :service_areas, dependent: :destroy
  has_many :statistics, through: :service_areas
  
  validates :name, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["name", "location", "created_at", "updated_at", "bilingual", "northern", "population"]
  end
  
  
  def self.ransackable_associations(auth_object = nil)
    ["service_areas", "statistics"]
  end
end