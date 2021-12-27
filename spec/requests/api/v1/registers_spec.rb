require 'rails_helper'

RSpec.describe 'Registers', :focus, type: :request do
  let(:company) { create(:company, :active) }
  let(:auth_data) { user.create_new_auth_token }
  let(:user) { create(:user, company: company) }
  let(:headers) do
    {
      'Accept': 'application/vnd.dipaz.v1',
      'Content-Type': Mime[:json].to_s,
      'access-token': auth_data['access-token'],
      'uid': auth_data['uid'],
      'client': auth_data['client']
    }
  end

  describe 'GET /companies/:id/registers' do
    context 'successfully' do
      let(:register) { create_list(:register, 20, company: company) }
      before do
        register
        get "/companies/#{company.id}/registers", params: {}, headers: headers
      end

      it { expect(response).to have_http_status :ok }
      it { expect(json_body[:register][0]).to have_key(:name) }
      it { expect(json_body[:register][0]).to have_key(:cpf) }
      it { expect(json_body[:register][0]).to have_key(:accession_at) }
      it 'returns list json data' do
        expect(json_body[:register].count).to eq(20)
      end
    end

    context 'failure' do
      let(:register) { create(:register) }
      before do
        register
        get "/companies/#{company.id}/registers", params: {}, headers: {}
      end

      it { expect(response).to have_http_status :unauthorized }
    end
  end

  describe 'GET /companies/:id/registers/:id' do
    let(:register) { create(:register, company: company) }

    context 'successfully' do
      before do
        get "/companies/#{company.id}/registers/#{register.id}", params: {}, headers: headers
      end

      it 'returns status code 200' do
        expect(response).to have_http_status :ok
      end
      it 'returns json data' do
        expect(json_body[:register]).to have_key(:name)
      end
    end

    context 'failure' do
      before { get "/companies/#{company.id}/registers/1000", params: {}, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
      end
      it 'returns error message' do
        expect(json_body[:errors]).to eq('Registro não cadastrado!')
      end
    end
  end

  describe 'POST /companies/:id/registers' do
    before do
      post "/companies/#{company.id}/registers", params: params_register.to_json, headers: headers
    end

    context 'successfully - create register' do
      let(:params_register) { attributes_for(:register) }

      it 'returns status code 201' do
        expect(response).to have_http_status :created
      end
      it 'return json data register created' do
        expect(json_body[:register][:name]).to eq(params_register[:name])
      end
    end

    context 'failure - create register' do
      let(:params_register) { attributes_for(:register, cpf: '') }

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
      end
      it 'return message errors' do
        expect(json_body[:errors]).to include('Cpf não é válido!')
      end
    end
  end

  describe 'PUT /companies/:id/registers/:id' do
    let(:register) { create(:register) }
    before do
      register
      put "/companies/#{company.id}/registers/#{register.id}", params: params_register.to_json, headers: headers
    end

    context 'update successfully' do
      let(:params_register) { { name: 'Ronaldo Vieira da Silva', rg: '362.321.84' } }

      it 'returns status code 200' do
        expect(response).to have_http_status :ok
      end
      it 'return json data register' do
        expect(json_body[:register][:name]).to eq(params_register[:name])
      end
    end

    context 'update - failure' do
      let(:params_register) { { accession_at: '' } }

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
      end
      it 'return message errors' do
        expect(json_body[:errors]).to include("Accession at can't be blank")
      end
    end
  end
end
