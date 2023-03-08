# frozen_string_literal: true

module AppCollections
  extend ActiveSupport::Concern

  included do
    helper_method :people_collection, :cars_collection
  end

  def people_collection
    Person
  end

  def cars_collection
    Car
  end
end
