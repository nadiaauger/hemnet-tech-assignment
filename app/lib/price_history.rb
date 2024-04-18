# frozen_string_literal: true

class PriceHistory
  def self.call(**options)
    # Feature request 2: Pricing History
    raise ArgumentError, "Package name required" unless options[:package].present?
    raise ArgumentError, "Year required" unless options[:year].present?

    year_int = options[:year].to_i
    prices = Price.filter_by_package_name_and_year(options[:package], year_int)

    if options[:municipality]
      prices = prices.filter_by_municipality(options[:municipality])
    end

    prices_grouped_by_municipality = prices.group_by(&:municipality)

    result = {}
    prices_grouped_by_municipality.each do |municipality, prices_for_municipality|
      result[municipality.name] = prices_for_municipality.pluck(:amount_cents)
    end

    result
  end
end
