require 'spec_helper'

require 'rantly'
require 'rantly/rspec_extensions'
require 'rantly/shrinks'
require 'money'
require 'json'

I18n.enforce_available_locales = false

describe 'Money' do
  cases = []

  after(:all) do
    File.open("#{__dir__}/__generated__/tested-cases-for-divmod.json", 'w') do |file|
      file.write(JSON.pretty_generate(cases))
    end
  end

  it '#divmod' do
    property_of do
      [range(1, 10), range(40, 50_000), range(1, 99)]
    end.check do |number_of_parcels, integer_part_of_value, decimal_part_of_value|
      number_of_parcels = number_of_parcels.abs
      total_value = Money.new(integer_part_of_value.abs * 100 + decimal_part_of_value.abs, 'USD')

      parcel_value, rest_value = total_value.divmod(number_of_parcels)

      recalculated_value = parcel_value * number_of_parcels + rest_value

      cases << {
          total_value: total_value,
          number_of_parcels: number_of_parcels,
          parcel_value: parcel_value,
          rest_value: rest_value
        }

      expect(total_value.cents).to be(recalculated_value.cents)
    end
  end
end
