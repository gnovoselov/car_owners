# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/cars', type: :request do
  let!(:owner) { create(:person) }
  let(:described_model) { Car }
  let(:valid_attributes) { attributes_for(:car, owner_id: owner.id) }
  let(:invalid_attributes) do
    attributes_for(:car, :negative_milage, owner_id: owner.id)
  end

  context 'when the user is not logged in' do
    it 'redirects to the login page' do
      get cars_url
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when the user is logged in' do
    let!(:user) { create(:user) }

    before(:each) { sign_in user }

    describe 'GET /index' do
      let!(:car) { create(:car) }

      before { get cars_url }

      it 'renders a successful response' do
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      let!(:car) { create(:car) }
      let(:headers) { {} }

      subject(:make_request) { get car_url(car), params: {}, headers: }

      it 'redirects to cars path' do
        make_request
        expect(response).to redirect_to(cars_path)
      end

      context 'when the car is not found' do
        let!(:car) { 0 }

        it 'raises a not found error' do
          expect { make_request }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when getting a car via turbo stream' do
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

      subject(:make_request) { get new_car_url, params: {}, headers: }

      it 'redirects to cars path' do
        make_request
        expect(response).to redirect_to(cars_path)
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
      let!(:car) { create(:car) }
      let(:headers) { {} }

      subject(:make_request) { get edit_car_url(car), params: {}, headers: }

      it 'redirects to cars path' do
        make_request
        expect(response).to redirect_to(cars_path)
      end

      context 'when the car is not found' do
        let!(:car) { 0 }

        it 'raises a not found error' do
          expect { make_request }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when getting a car via turbo stream' do
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

      subject(:post_car) do
        post cars_url, params:, headers:
      end

      context 'with valid parameters' do
        let(:params) { { car: valid_attributes } }

        it 'creates a new car' do
          expect { post_car }.to change(described_model, :count).by(1)
        end

        context 'when the car is created' do
          before { post_car }

          it 'redirects to the created car' do
            expect(response).to redirect_to(car_url(described_model.last))
          end

          context 'via turbo stream' do
            let(:headers) { turbo_frame_header }
            let(:params) { { car: valid_attributes, format: :turbo_stream } }

            it 'renders a successful response' do
              expect(response).to have_http_status(:ok)
              expect(response.media_type).to eq Mime[:turbo_stream]
              expect(response.body).to include('<turbo-stream action="replace" target="cars-table">')
            end
          end
        end
      end

      context 'with invalid parameters' do
        let(:params) { { car: invalid_attributes } }

        it 'does not create a new car' do
          expect { post_car }.to change(described_model, :count).by(0)
        end

        context 'after the create attempt' do
          before { post_car }

          it "renders a response with 422 status (i.e. to display the 'new' template)" do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end

    describe 'PATCH /update' do
      let!(:car) { create(:car) }
      let(:headers) { {} }

      subject(:patch_car) do
        patch car_url(car), params:, headers:
      end

      before { patch_car }

      context 'with valid parameters' do
        let(:params) { { car: valid_attributes } }

        it 'updates the requested car' do
          expect(car.reload).to have_attributes(params[:car])
        end

        it 'redirects to the car' do
          expect(response).to redirect_to(car_url(car))
        end

        context 'via turbo stream' do
          let(:headers) { turbo_frame_header }
          let(:params) { { car: valid_attributes, format: :turbo_stream } }

          it 'renders a successful response' do
            expect(response).to have_http_status(:ok)
            expect(response.media_type).to eq Mime[:turbo_stream]
            expect(response.body).to include('<turbo-stream action="replace" target="cars-table">')
          end
        end
      end

      context 'with invalid parameters' do
        let(:params) { { car: invalid_attributes } }

        it "renders a response with 422 status (i.e. to display the 'edit' template)" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE /destroy' do
      let!(:car) { create(:car) }
      let(:headers) { {} }
      let(:params) { {} }

      subject(:delete_car) do
        delete car_url(car), params:, headers:
      end

      it 'destroys the requested car' do
        expect { delete_car }.to change(described_model, :count).by(-1)
      end

      context 'when the car is destroyed' do
        before { delete_car }

        it 'redirects to the cars list' do
          expect(response).to redirect_to(cars_url)
        end

        context 'via turbo stream' do
          let(:headers) { turbo_frame_header }
          let(:params) { { car: valid_attributes, format: :turbo_stream } }

          it 'renders a successful response' do
            expect(response).to have_http_status(:ok)
            expect(response.media_type).to eq Mime[:turbo_stream]
            expect(response.body).to include('<turbo-stream action="replace" target="cars-table">')
          end
        end
      end
    end
  end
end
