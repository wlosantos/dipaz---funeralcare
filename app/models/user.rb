# frozen_string_literal: true

class User < ActiveRecord::Base
  belongs_to :company
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  enum status: %i[active inactive]

  validates :name, presence: true
  validates :phone, presence: true
end
