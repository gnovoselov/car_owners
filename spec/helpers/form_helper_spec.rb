# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormHelper, type: :helper do
  let(:rendered_field) { content_tag(:input) }
  let(:form) do
    double(
      'form',
      text_field: rendered_field,
      select: rendered_field,
      object: double(
        'object',
        errors: double(
          'errors',
          '[]': %w[error1 error2]
        )
      )
    )
  end

  describe '.errors_for' do
    let(:field) { :field }

    subject { helper.errors_for(form, field) }

    it { is_expected.to include('div class="invalid-feedback"') }

    it 'renders first error for the field' do
      expect(strip_tags(subject)).to eq('error1')
    end
  end

  describe '.input_group_for' do
    let(:field) { :field }
    let(:options) { {} }

    subject { helper.input_group_for(form, field, options) }

    before do
      allow(helper).to receive(:errors_for).and_return('')
      allow(helper).to receive(:render_field).and_return('')
    end

    it { is_expected.to include('div class="input-group has-validation"') }

    it { is_expected.to include('span class="input-group-text"') }

    it 'renders the label' do
      expect(strip_tags(subject)).to eq(field.to_s.camelize)
    end

    it 'calls errors_for' do
      expect(helper).to receive(:errors_for).with(form, field)
      subject
    end

    it 'calls render_field with errors' do
      expect(helper).to receive(:render_field).with(form, field, true, options)
      subject
    end

    context 'when there are no errors' do
      let(:form) do
        double(
          'form',
          text_field: rendered_field,
          object: double(
            'object',
            errors: double(
              'errors',
              '[]': []
            )
          )
        )
      end

      it 'does not call errors_for' do
        expect(helper).not_to receive(:errors_for)
        subject
      end

      it 'calls render_field with no errors' do
        expect(helper).to receive(:render_field).with(form, field, false, options)
        subject
      end
    end

    context 'when label is passed' do
      let(:options) { { label: 'SOME_LABEL_SUBSTITUTION' } }

      it 'renders the label' do
        expect(strip_tags(subject)).to eq('SOME_LABEL_SUBSTITUTION')
      end
    end
  end

  describe '.form_group_for' do
    let(:field) { :field }
    let(:options) { { some: :option } }
    let(:form) { double(:form, label: content_tag(:label, '', class: 'form-label')) }

    subject { helper.form_group_for(form, field, options) }

    before do
      allow(helper).to receive(:input_group_for).and_return('')
    end

    it { is_expected.to include(%(div class="field-#{field}-container col-12 mb-3")) }

    it { is_expected.to include('label class="form-label"') }

    it 'calls input_group_for' do
      expect(helper).to receive(:input_group_for).with(form, field, options)
      subject
    end
  end

  describe '.render_field' do
    let(:field) { :field }
    let(:has_errors) { Faker::Boolean.boolean }
    let(:options) { {} }

    subject { helper.render_field(form, field, has_errors, options) }

    before do
      allow(helper).to receive(:render_select).and_return('')
      allow(helper).to receive(:render_text_field).and_return('')
    end

    it 'calls render_text_field' do
      expect(helper).to receive(:render_text_field).with(form, field, has_errors)
      subject
    end

    context 'when type is passed' do
      let(:options) { { type: field_type } }
      let(:field_type) { :check_box }

      it 'calls render_text_field' do
        expect(helper).to receive(:render_text_field).with(form, field, has_errors)
        subject
      end

      context 'and equals select' do
        let(:field_type) { :select }

        it 'calls render_select' do
          expect(helper).to receive(:render_select).with(form, field, has_errors, options)
          subject
        end
      end
    end
  end

  describe '.render_select' do
    let(:field) { :field }
    let(:has_errors) { false }
    let(:options) { {} }

    subject { helper.render_select(form, field, has_errors, options) }

    it 'renders select' do
      expect(form).to receive(:select).with(field, [], {}, class: 'form-control form-select ')
      subject
    end

    context 'when there are errors' do
      let(:has_errors) { true }

      it 'renders text_field with error class' do
        expect(form).to receive(:select).with(field, [], {}, class: 'form-control form-select is-invalid')
        subject
      end
    end

    context 'when collection passed' do
      let(:people) { build_list(:person, 2) }
      let(:options) { { collection: people } }

      it 'renders text_field with error class' do
        expect(form).to receive(:select).with(field, people, {}, class: 'form-control form-select ')
        subject
      end
    end
  end

  describe '.render_text_field' do
    let(:field) { :field }
    let(:has_errors) { false }

    subject { helper.render_text_field(form, field, has_errors) }

    it 'renders text_field' do
      expect(form).to receive(:text_field).with(field, class: 'form-control ')
      subject
    end

    context 'when there are errors' do
      let(:has_errors) { true }

      it 'renders text_field with error class' do
        expect(form).to receive(:text_field).with(field, class: 'form-control is-invalid')
        subject
      end
    end
  end
end
