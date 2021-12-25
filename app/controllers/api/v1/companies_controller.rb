module Api
  module V1
    # adding controller of companies
    class CompaniesController < ApplicationController
      def index
        company = Company.first
        if company.active?
          render json: { company: company }, status: :ok
        else
          render json: { errors: { message: 'Company blocked. Contact support!' } }, status: :unauthorized
        end
      end
    end
  end
end
