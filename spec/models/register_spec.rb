require 'rails_helper'

RSpec.describe Register, type: :model do
  context 'indexes' do
    it { is_expected.to have_db_index(:company_id) }
    it { is_expected.to have_db_index(:cpf).unique(true) }
  end

  describe 'must be present' do
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:birthday).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:rg).of_type(:string) }
    it { is_expected.to have_db_column(:cpf).of_type(:string) }
    it { is_expected.to have_db_column(:accession_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:plan).of_type(:integer).with_options(default: :titular) }
    it { is_expected.to have_db_column(:status).of_type(:integer).with_options(default: :active) }
    it { is_expected.to have_db_column(:company_id).of_type(:integer) }
  end

  context 'adding attributes' do
    let(:accession) { Time.now }
    let(:register) { build(:register, accession_at: accession, cpf: '460.797.933-34', rg: '1.502.944-MA') }

    it { expect(register).to have_attributes(accession_at: accession) }
    it { expect(register).to have_attributes(cpf: '460.797.933-34') }
    it { expect(register).to have_attributes(rg: '1.502.944-MA') }
    it { expect(register).to have_attributes(plan: 'titular') }
    it { expect(register).to have_attributes(status: 'active') }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :birthday }
    it { is_expected.to validate_presence_of :accession_at }
    it { is_expected.to validate_presence_of :plan }
    it { is_expected.to validate_presence_of :status }
    it { is_expected.to define_enum_for(:plan).with_values(%i[titular dependent]) }
    it { is_expected.to define_enum_for(:status).with_values(%i[active inactive]) }
  end

  context 'relationship' do
    it { is_expected.to belong_to :company }
  end

  context 'persisted in database' do
    context 'successfully' do
      it { expect(create(:register)).to be_valid }
    end
    context 'failure' do
      let(:register) { create(:register, :cpf_invalid) }
      let(:register1) { create(:register, cpf: '460.797.933-34') }
      let(:register2) { create(:register, cpf: '460.797.933-34') }

      before do
        register1
      end

      it 'cpf invalid' do
        expect { register }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'cpj already registered' do
        expect { register2 }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
