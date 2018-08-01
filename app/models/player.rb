class Player < ApplicationRecord
  validates :slack_name, uniqueness: { scope: :tournament_id, message: "already entered the tournament" }

  belongs_to :tournament
end
