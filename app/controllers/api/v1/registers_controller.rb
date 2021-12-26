module Api
  module V1
    # Controller for registers
    class RegistersController < BasicController
      before_action :set_company
      def index
        register = @company.registers.all
        render json: { register: register }, status: :ok
      end

      private

      def set_company
        @company = current_user.company
      end
    end
  end
end
