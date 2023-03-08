# frozen_string_literal: true

module FormHelper
  def errors_for(form, field)
    content_tag(:div, form.object.errors[field].try(:first), class: 'invalid-feedback')
  end

  def input_group_for(form, field, opts = {})
    label = opts.fetch(:label) { t(field) }
    has_errors = form.object.errors[field].present?

    content_tag :div, class: 'input-group has-validation' do
      concat content_tag(:span, label, class: 'input-group-text')
      concat render_field(form, field, has_errors, opts)
      concat errors_for(form, field) if has_errors
    end
  end

  def form_group_for(form, field, opts = {})
    content_tag :div, class: "field-#{field}-container col-12 mb-3" do
      concat form.label(field, class: 'form-label')
      concat input_group_for(form, field, opts)
    end
  end

  def render_field(form, field, has_errors, opts = {})
    type = opts.fetch(:type, :text_field)

    case type
    when :select then render_select(form, field, has_errors, opts)
    else render_text_field(form, field, has_errors)
    end
  end

  def render_select(form, field, has_errors, opts = {})
    collection = opts.fetch(:collection, [])

    form.select field, collection, {}, class: "form-control form-select #{'is-invalid' if has_errors}"
  end

  def render_text_field(form, field, has_errors)
    form.text_field(field, class: "form-control #{'is-invalid' if has_errors}")
  end
end
