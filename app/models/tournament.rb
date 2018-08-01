class Tournament < ApplicationRecord
  validates :name, uniqueness: true
  has_many :players
end
