# frozen_string_literal: true

module CommonHelpers
  module_function

  extend ActionDispatch::TestProcess

  def turbo_frame_header
    { 'Turbo-Frame': :modal }
  end

  def mock_pagy
    Pagy.new(count: 1000, page: 10, size: [3, 4, 4, 3])
  end
end
