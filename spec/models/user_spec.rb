require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'indexes' do
    it { is_expected.to have_db_index(:company_id) }
  end

  describe 'aditional columns' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:phone).of_type(:string) }
    it { is_expected.to have_db_column(:status).of_type(:integer) }
  end

  describe 'attributes' do
    let(:user) { build(:user, name: 'Rodrigo Fontenelle', phone: '21 96981-3737', status: 'active') }

    it { expect(user).to have_attributes(name: 'Rodrigo Fontenelle') }
    it { expect(user).to have_attributes(phone: '21 96981-3737') }
    it { expect(user).to have_attributes(status: 'active') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :phone }
    it { is_expected.to define_enum_for(:status).with_values(%i[active inactive]) }
  end

  describe 'relationship' do
    it { is_expected.to belong_to :company }
  end

  describe 'create user' do
    it { expect(build(:user)).to be_valid }
  end
end
