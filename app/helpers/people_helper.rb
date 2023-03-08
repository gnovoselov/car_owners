# frozen_string_literal: true

module PeopleHelper
  def owner_info_link(person)
    turbo_frame_button(person, 'view-owner-button') do
      person.name
    end
  end
end
