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

  describe '#approved_cnpj?' do
    context 'valid' do
      let(:company) { build(:company) }
      it { expect(company.approved_cnpj?).to be_truthy }
    end
    context 'invalid' do
      let(:company) { build(:company, cnpj: '111') }
      before { company.save }
      it { expect(company.approved_cnpj?).to be_falsy }
      it { expect(company.errors.full_messages).to include('Cnpj precisa ser preenchido corretamente') }
      it { expect(company.errors.full_messages).to include('Cnpj inválido!') }
    end
  end
end
