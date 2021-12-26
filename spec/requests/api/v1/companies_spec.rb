require 'rails_helper'

RSpec.describe 'Companies', type: :request do
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

  describe 'GET /companies' do
    context 'successfully' do
      before do
        sign_in user
        company
        get '/companies', params: {}, headers: headers
      end

      it { expect(response).to have_http_status :ok }
      it { expect(json_body[:company]).to have_key(:name) }
      it { expect(json_body[:company]).to have_key(:cnpj) }
      it { expect(json_body[:company][:status]).to eq('active') }
    end

    context 'failure - access not allowed' do
      let(:company) { create(:company) }
      before do
        company
        get '/companies', params: {}, headers: headers
      end

      it { expect(response).to have_http_status :unauthorized }
      it 'status blocked' do
        expect(json_body[:errors][:message]).to eq('Company blocked. Contact support!')
      end
    end
  end

  describe 'PUT /companies/:id' do
    before do
      company
      put "/companies/#{company.id}", params: params_company.to_json, headers: headers
    end

    context 'successfully' do
      let(:params_company) { attributes_for(:company, name: 'Osy Updated') }
      it { expect(response).to have_http_status :ok }
      it 'return update data json' do
        expect(json_body[:company][:name]).to eq(params_company[:name])
      end
    end

    context 'failure' do
      context 'not permited parametes' do
        let(:params_company) { attributes_for(:company, cnpj: '11.006.382/0001-87') }
        it { expect(json_body[:company][:cnpj]).to_not eq(params_company[:cnpj]) }
      end
      context 'can not be blank or nil' do
        let(:params_company) { attributes_for(:company, name: '') }
        it { expect(json_body[:errors][:message].to_sentence).to eq("Name can't be blank") }
        it { expect(response).to have_http_status :unprocessable_entity }
      end
    end
  end
end
