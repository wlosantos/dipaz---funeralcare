require 'rails_helper'

RSpec.describe 'Companies', :focus, type: :request do
  let(:headers) do
    {
      'Accept': 'application/vnd.dipaz.v1',
      'Content-Type': Mime[:json].to_s
      # 'access-token': auth_data['access-token'],
      # 'uid': auth_data['uid'],
      # 'client': auth_data['client']
    }
  end

  describe 'GET /companies' do
    context 'successfully' do
      let(:company) { create(:company, :active) }
      before do
        company
        get '/companies', params: {}, headers: headers
      end

      it { expect(response).to have_http_status :ok }
      it { expect(json_body[:company]).to have_key(:name) }
      it { expect(json_body[:company]).to have_key(:cnpj) }
      it { expect(json_body[:company][:status]).to eq('active') }
    end

    context 'failure' do
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
end
