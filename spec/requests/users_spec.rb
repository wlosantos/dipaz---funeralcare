require 'rails_helper'

RSpec.describe 'Users - Request', type: :request do
  let!(:user) { create(:user) }
  let(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'Accept': 'application/vnd.dipaz.v1',
      'Content-Type': Mime[:json].to_s,
      'access-token': auth_data['access-token'],
      'uid': auth_data['uid'],
      'client': auth_data['client']
    }
  end

  describe 'validate_token' do
    context 'be valid' do
      before { get '/api/auth/validate_token', params: {}, headers: headers }

      it 'returns status code 200' do
        expect(response).to have_http_status :ok
      end
      it 'return the user' do
        expect(json_body[:data][:id].to_i).to eq(user.id)
      end
    end

    context 'are invalid' do
      before do
        headers['access-token'] = 'invalid_token'
        get '/api/auth/validate_token', params: {}, headers: headers
      end

      it 'returns status code 422' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'create user' do
    before { post '/api/auth', params: user_params.to_json, headers: headers }

    context 'params are valid' do
      let(:user_params) { attributes_for(:user) }

      # it 'returns status code 200' do
      #   expect(response).to have_http_status :ok
      # end
      it 'return json data user' do
        expect(json_body[:data][:email]).to eq(user_params[:email])
      end
    end

    context 'params invalid' do
      let(:user_params) { attributes_for(:user, :email_invalid) }

      it 'returns the status code 401' do
        expect(response).to have_http_status :unprocessable_entity
      end
      it 'return the data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'update user' do
    before { put '/api/auth', params: user_params.to_json, headers: headers }

    context 'params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'returns status code 200' do
        expect(response).to have_http_status :ok
      end
      it 'return json data update user' do
        expect(json_body[:data][:email]).to eq(user_params[:email])
      end
    end

    context 'params are invalid' do
      let(:user_params) { { email: 'invalid@' } }

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
      end
      it 'returns json data errors key' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'delete user' do
    before { delete '/api/auth', params: {}, headers: headers }

    context 'delete users are valid' do
      it 'return status code 200' do
        expect(response).to have_http_status :ok
      end
      it 'removes the user from database' do
        expect(User.find_by_id(user.id)).to be_nil
      end
    end
  end
end
