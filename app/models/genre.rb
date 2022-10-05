class Genre < ApplicationRecord
  has_many :characterizations
  has_many :movies, through: :characterizations
  validates :name, presence: true, uniqueness: true
end
