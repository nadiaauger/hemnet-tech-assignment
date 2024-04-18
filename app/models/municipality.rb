# frozen_string_literal: true

class Municipality < ApplicationRecord
  has_many :prices, dependent: :destroy

  validates :name, presence: true
end
