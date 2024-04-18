# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PriceHistory do
  describe '.call' do
    let(:year) { 2024 }
    let(:package_name) { "plus" }

    context 'with valid arguments' do
      it 'returns price history grouped by municipality' do
          stockholm = Municipality.create!(name: 'Stockholm')
          goteborg = Municipality.create!(name: 'Göteborg')
          plus = Package.create!(name: 'plus', amount_cents: 1000)
          premium = Package.create!(name: 'premium', amount_cents: 1500)

          Price.create!(municipality: stockholm, package: plus, amount_cents: 1000)
          Price.create!(municipality: stockholm, package: plus, amount_cents: 1200)
          Price.create!(municipality: goteborg, package: plus, amount_cents: 1500)
          Price.create!(municipality: stockholm, package: premium, amount_cents: 1200)

        result = PriceHistory.call(package: plus.name, year: year)
        expect(result.keys).to contain_exactly('Stockholm', 'Göteborg')
        expect(result['Stockholm']).to contain_exactly(1000, 1200)
        expect(result['Göteborg']).to contain_exactly(1500)
      end

      it 'filters by municipality if provided' do
        stockholm = Municipality.create!(name: 'Stockholm')
        goteborg = Municipality.create!(name: 'Göteborg')
        plus = Package.create!(name: 'plus', amount_cents: 1000)
        premium = Package.create!(name: 'premium', amount_cents: 1500)

        Price.create!(municipality: stockholm, package: plus, amount_cents: 1000)
        Price.create!(municipality: stockholm, package: plus, amount_cents: 1200)
        Price.create!(municipality: goteborg, package: plus, amount_cents: 1500)
        Price.create!(municipality: stockholm, package: premium, amount_cents: 1200)

        result = PriceHistory.call(package: package_name, year: year, municipality: 'Stockholm')
        expect(result.keys).to contain_exactly('Stockholm')
        expect(result['Stockholm']).to contain_exactly(1000, 1200)
      end
    end

    context 'with missing arguments' do
      it 'raises ArgumentError if package name is missing' do
        expect { PriceHistory.call(year: year) }.to raise_error(ArgumentError, /Package name required/)
      end

      it 'raises ArgumentError if year is missing' do
        expect { PriceHistory.call(package: package_name) }.to raise_error(ArgumentError, /Year required/)
      end
    end
  end
end
