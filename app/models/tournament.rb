class Tournament < ApplicationRecord
  validates :name, uniqueness: true
end
