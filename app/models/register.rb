class Register < ApplicationRecord
  belongs_to :company, inverse_of: :registers

  enum plan: %i[titular dependent]
  enum status: %i[active inactive]

  validates :name, presence: true
  validates :birthday, presence: true
  validates :accession_at, presence: true
  validates :plan, :status, presence: true
  validates :cpf, presence: true,
                  uniqueness: { message: 'já cadastrado' },
                  length: { minimum: 14, message: 'precisa ser preenchido corretamente' }

  before_validation :allow_create?, on: :create
  before_validation :allow_update?, on: :update

  private

  def cpf_valid?
    return true if CPF.valid?(cpf)

    errors.add(:cpf, 'não é válido!')
    false
  end

  def cpf_not_exists?
    return true if Register.where(cpf: cpf).first.nil?

    errors.add(:cpf, 'já cadastrado!')
    false
  end

  def cpf_approved?
    cpf_valid? && !cpf_not_exists?
  end

  def allow_create?
    cpf_approved?
  end

  def allow_update?
    return false if cpf_changed? && !cpf_approved?

    true
  end
end
