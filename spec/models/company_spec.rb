require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'database' do
    context 'indexes' do
      it { is_expected.to have_db_index(:cnpj).unique(true) }
    end

    context 'columns' do
      it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:cnpj).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:domain).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }
    end

    context 'attributes' do
      let(:company) do
        build(:company, name: 'w3n design', cnpj: '11.006.382/0001-87', domain: 'w3ndesign.com', status: 'active')
      end
      it { expect(company).to have_attributes(name: 'w3n design') }
      it { expect(company).to have_attributes(cnpj: '11.006.382/0001-87') }
      it { expect(company).to have_attributes(domain: 'w3ndesign.com') }
      it { expect(company).to have_attributes(status: 'active') }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :cnpj }
    it { is_expected.to define_enum_for(:status).with_values(%i[active blocked]) }
  end

  describe 'persisted database' do
    context 'successfully' do
      let(:company) { create(:company) }
      let(:data) { Company.last }
      before do
        company
        data
      end
      it 'created' do
        expect(company).to be_valid
      end
      it 'find company' do
        expect(data.name).to eq(company.name)
      end
    end

    context 'failure - Record::Invalid' do
      let(:company) { create(:company, name: '') }
      it 'can\'t be blank' do
        expect { company }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'failure - CNPJ já cadastrado' do
      let(:company) { create(:company, cnpj: '11.006.382/0001-87') }
      let(:company2) { create(:company, cnpj: '11.006.382/0001-87') }
      before do
        company
      end

      it '' do
        expect do
          company2
        end.to raise_error(ActiveRecord::RecordInvalid,
                           'Validation failed: Cnpj já cadastrado!, Cnpj Empresa já cadastrada com esse CNPJ')
      end
    end
  end
end
