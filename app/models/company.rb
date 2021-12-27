class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :registers, dependent: :destroy

  enum status: %i[active blocked]

  validates :name, presence: true
  validates :cnpj, presence: true,
                   uniqueness: { message: 'Empresa já cadastrada com esse CNPJ' },
                   length: { minimum: 18, message: 'precisa ser preenchido corretamente' }

  before_validation :allow_create?, on: :create
  before_validation :allow_update?, on: :update

  private

  def cnpj_valid?
    return true if CNPJ.valid?(cnpj)

    errors.add(:cnpj, 'não é valido!')
    false
  end

  def cnpj_not_exists?
    return true if Company.where(cnpj: cnpj).first.nil?

    errors.add(:cnpj, 'já cadastrado!')
    false
  end

  def cnpj_approved?
    cnpj_valid? && !cnpj_not_exists?
  end

  def allow_create?
    cnpj_approved?
  end

  def allow_update?
    return false if cnpj_changed? && !cnpj_approved?

    true
  end
end
