# frozen_string_literal: true

class User < ActiveRecord::Base
  rolify
  belongs_to :company, inverse_of: :users
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  enum status: %i[active inactive]

  validates :name, presence: true
  validates :phone, presence: true

  # after_create :assign_default_role

  # def assign_default_role
  #   add_role(:client) if roles.blank?
  # end
end
