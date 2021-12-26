module Api
  module V1
    # adding controller of companies
    class CompaniesController < BasicController
      def index
        company = current_user.company
        if company.active?
          render json: { company: company }, status: :ok
        else
          render json: { errors: { message: 'Company blocked. Contact support!' } }, status: :unauthorized
        end
      end

      def update
        company = Company.find(params[:id])
        if company.update(params_company)
          render json: { company: company }, status: :ok
        else
          render json: { errors: { message: company.errors.full_messages } }, status: :unprocessable_entity
        end
      end

      private

      def params_company
        params.require(:company).permit(:name, :domain)
      end
    end
  end
end
