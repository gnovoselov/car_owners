# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/people', type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Person. As you add validations to Person, be sure to
  # adjust the attributes here as well.
  let(:described_model) { Person }
  let(:valid_attributes) { attributes_for(:person) }
  let(:invalid_attributes) { attributes_for(:person, :invalid_email) }

  describe 'GET /index' do
    let!(:person) { create(:person) }

    before { get people_url }

    it 'renders a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    let!(:person) { create(:person) }
    let(:headers) { {} }

    subject(:make_request) { get person_url(person), params: {}, headers: }

    it 'redirects to root path' do
      make_request
      expect(response).to redirect_to(root_path)
    end

    context 'when the person is not found' do
      let!(:person) { 0 }

      it 'raises a not found error' do
        expect { make_request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when getting a person via turbo stream' do
      let(:headers) { turbo_frame_header }

      before { make_request }

      it 'renders a successful response' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('<turbo-frame id="modal">')
      end
    end
  end

  describe 'GET /new' do
    let(:headers) { {} }

    subject(:make_request) { get new_person_url, params: {}, headers: }

    it 'redirects to root path' do
      make_request
      expect(response).to redirect_to(root_path)
    end

    context 'when getting the form via turbo stream' do
      let(:headers) { turbo_frame_header }

      before { make_request }

      it 'renders a successful response' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('<turbo-frame id="modal">')
      end
    end
  end

  describe 'GET /edit' do
    let!(:person) { create(:person) }
    let(:headers) { {} }

    subject(:make_request) { get edit_person_url(person), params: {}, headers: }

    it 'redirects to root path' do
      make_request
      expect(response).to redirect_to(root_path)
    end

    context 'when the person is not found' do
      let!(:person) { 0 }

      it 'raises a not found error' do
        expect { make_request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when getting a person via turbo stream' do
      let(:headers) { turbo_frame_header }

      before { make_request }

      it 'renders a successful response' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('<turbo-frame id="modal">')
      end
    end
  end

  describe 'POST /create' do
    let(:headers) { {} }

    subject(:post_person) do
      post people_url, params:, headers:
    end

    context 'with valid parameters' do
      let(:params) { { person: valid_attributes } }

      it 'creates a new Person' do
        expect { post_person }.to change(described_model, :count).by(1)
      end

      context 'when the person is created' do
        before { post_person }

        it 'redirects to the created person' do
          expect(response).to redirect_to(person_url(described_model.last))
        end

        context 'via turbo stream' do
          let(:headers) { turbo_frame_header }
          let(:params) { { person: valid_attributes, format: :turbo_stream } }

          it 'renders a successful response' do
            expect(response).to have_http_status(:ok)
            expect(response.media_type).to eq Mime[:turbo_stream]
            expect(response.body).to include('<turbo-stream action="replace" target="people-table">')
          end
        end
      end
    end

    context 'with invalid parameters' do
      let(:params) { { person: invalid_attributes } }

      it 'does not create a new Person' do
        expect { post_person }.to change(Person, :count).by(0)
      end

      context 'after the create attempt' do
        before { post_person }

        it "renders a response with 422 status (i.e. to display the 'new' template)" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PATCH /update' do
    let!(:person) { create(:person) }
    let(:headers) { {} }

    subject(:patch_person) do
      patch person_url(person), params:, headers:
    end

    before { patch_person }

    context 'with valid parameters' do
      let(:params) { { person: valid_attributes } }

      it 'updates the requested person' do
        expect(person.reload).to have_attributes(params[:person])
      end

      it 'redirects to the person' do
        expect(response).to redirect_to(person_url(person))
      end

      context 'via turbo stream' do
        let(:headers) { turbo_frame_header }
        let(:params) { { person: valid_attributes, format: :turbo_stream } }

        it 'renders a successful response' do
          expect(response).to have_http_status(:ok)
          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include('<turbo-stream action="replace" target="people-table">')
        end
      end
    end

    context 'with invalid parameters' do
      let(:params) { { person: invalid_attributes } }

      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:person) { create(:person) }
    let(:headers) { {} }
    let(:params) { {} }

    subject(:delete_person) do
      delete person_url(person), params:, headers:
    end

    it 'destroys the requested person' do
      expect { delete_person }.to change(Person, :count).by(-1)
    end

    context 'when the person is destroyed' do
      before { delete_person }

      it 'redirects to the people list' do
        expect(response).to redirect_to(people_url)
      end

      context 'via turbo stream' do
        let(:headers) { turbo_frame_header }
        let(:params) { { person: valid_attributes, format: :turbo_stream } }

        it 'renders a successful response' do
          expect(response).to have_http_status(:ok)
          expect(response.media_type).to eq Mime[:turbo_stream]
          expect(response.body).to include('<turbo-stream action="replace" target="people-table">')
        end
      end
    end
  end
end
