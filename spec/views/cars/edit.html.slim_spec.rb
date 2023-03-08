# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'cars/edit', type: :view do
  let!(:car) { create(:car) }

  before do
    assign(:car, car)
    render
  end

  it 'renders the edit car form' do
    assert_select 'form[action=?][method=?]', car_path(car), 'post' do
      assert_select 'input[name=?]', 'car[model]'
      assert_select 'input[name=?]', 'car[make]'
      assert_select 'input[name=?]', 'car[color]'
      assert_select 'input[name=?]', 'car[milage]'
      assert_select 'select[name=?]', 'car[owner_id]'
      assert_select 'input[name=?]', 'car[is_for_sale]'
    end
  end
end
