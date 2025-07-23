class ServiceArea < ApplicationRecord
  belongs_to :library
  has_many :statistics, dependent: :destroy
  
  validates :name, presence: true
  validates :name, uniqueness: { scope: :library_id }

  def self.ransackable_attributes(auth_object = nil)
    ["name", "location", "created_at", "updated_at", "population", "municipality"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["statistics", "library"] 
  end
end