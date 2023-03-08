# frozen_string_literal: true

# Remove the default error wrapper
# Will prevent wrapping fields in div.field_with_errors
ActionView::Base.field_error_proc = proc do |html_tag, _instance|
  html_tag.html_safe # rubocop:disable Rails/OutputSafety
end
