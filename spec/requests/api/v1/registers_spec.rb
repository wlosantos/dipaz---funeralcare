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
end
