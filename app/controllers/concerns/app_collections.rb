# frozen_string_literal: true

module AppCollections
  extend ActiveSupport::Concern

  def people_collection
    Person
  end
end
