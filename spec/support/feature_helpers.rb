# frozen_string_literal: true

module FeatureHelpers
  module_function

  def fill_form_data(data)
    data.each do |(field, value)|
      fill_in field.to_s.capitalize, with: value
    end
  end
end
