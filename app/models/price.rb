# frozen_string_literal: true

class Price < ApplicationRecord
  belongs_to :package, optional: false
  belongs_to :municipality, optional: false

  validates :amount_cents, presence: true

  scope :filter_by_package_name_and_year, ->(package_name, year) {
    joins(:package)
      .where(packages: { name: package_name })
      .where(created_at: Date.new(year, 1, 1)..Date.new(year, 12, 31))
  }

  scope :filter_by_municipality, ->(municipality_name) {
    joins(:municipality)
      .where(municipalities: { name: municipality_name })
  }
end
