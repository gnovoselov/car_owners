# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'people/edit', type: :view do
  let!(:person) { create(:person) }

  before(:each) { assign(:person, person) }

  it 'renders the edit person form' do
    render

    assert_select 'form[action=?][method=?]', person_path(person), 'post' do
      assert_select 'input[name=?]', 'person[name]'

      assert_select 'input[name=?]', 'person[email]'

      assert_select 'input[name=?]', 'person[phone]'
    end
  end
end
