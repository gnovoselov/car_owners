# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'people/new', type: :view do
  before do
    assign(:person, build(:person))
    render
  end

  it 'renders new person form' do
    assert_select 'form[action=?][method=?]', people_path, 'post' do
      assert_select 'input[name=?]', 'person[name]'
      assert_select 'input[name=?]', 'person[email]'
      assert_select 'input[name=?]', 'person[phone]'
    end
  end
end
