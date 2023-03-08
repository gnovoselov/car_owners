# frozen_string_literal: true

module CarsHelper
  def car_info_link(car)
    return '' unless car

    turbo_frame_button(car, 'view-car-button') do
      car_full_name(car)
    end
  end

  def car_full_name(car)
    return '' unless car

    "#{car.make} #{car.model}"
  end

  def car_for_sale(car)
    return yes_icon if car.is_for_sale

    no_icon
  end

  def owner_class(car)
    car.class.reflect_on_association(:owner).klass
  end

  def owners_for_select(car, people_collection)
    options_for_select(
      [[t('select_one'), '']] +
        people_collection.all.map { |person| [person.name, person.id] },
      car.owner_id
    )
  end

  def yes_icon
    bootstrap_icon('check2', width: 15, height: 15, class: 'text-success')
  end

  def no_icon
    bootstrap_icon('x', width: 15, height: 15, class: 'text-danger')
  end
end
