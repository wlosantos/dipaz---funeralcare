module Api
  module V1
    # Controller for registers
    class RegistersController < BasicController
      before_action :set_company

      def index
        register = @company.registers.all
        render json: { register: register }, status: :ok
      end

      def show
        register = Register.find(params[:id])
        render json: { register: register }, status: :ok
      rescue StandardError
        render json: { errors: 'Registro não cadastrado!' }, status: :unprocessable_entity
      end

      private

      def set_company
        @company = current_user.company
      end
    end
  end
end
