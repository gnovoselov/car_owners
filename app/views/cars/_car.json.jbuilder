# frozen_string_literal: true

json.extract! car, :id, :model, :make, :color, :milage, :owner_id, :is_for_sale, :created_at, :updated_at
json.url car_url(car, format: :json)
