class Company < ApplicationRecord
  enum status: %i[active blocked]

  validates :name, presence: true
  validates :cnpj, presence: true,
                   uniqueness: { message: 'Empresa já cadastrada com esse CNPJ' },
                   length: { minimum: 18, message: 'precisa ser preenchido corretamente' }

  before_validation :approved_cnpj?

  def approved_cnpj?
    cnpj_valid? && !cnpj_not_exists?
  end

  private

  def cnpj_valid?
    errors.add(:cnpj, 'inválido!') unless CNPJ.valid?(cnpj)
    CNPJ.valid?(cnpj)
  end

  def cnpj_not_exists?
    return true if Company.where(cnpj: cnpj).first.nil?

    errors.add(:cnpj, 'já cadastrado!')
    false
  end
end
