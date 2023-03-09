# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def active_class(link_path)
    current_page?(link_path) ? 'text-white' : 'text-secondary'
  end

  def turbo_frame_button(destination, class_name = '', &)
    button_to(destination, method: :get, class: "#{class_name} btn btn-link p-0",
                           data: { turbo_frame: 'modal', bs_toggle: 'modal', bs_target: '#modalDialog' }, &)
  end

  def format_date(date)
    return '' unless date

    date.strftime('%d %b %Y')
  end

  def history_header(parent, ownership)
    if parent.is_a?(Person)
      "#{car_full_name(ownership.car)} (#{ownership.car.color})"
    else
      ownership.person.name
    end
  end
end
