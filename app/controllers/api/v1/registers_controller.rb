module Api
  module V1
    # Controller for registers
    class RegistersController < BasicController
      before_action :set_company

      def index
        register = RegisterPresenter.new(@company.registers.all)
        render json: { registers: register.list }, status: :ok
      end

      def show
        register = RegisterPresenter.new(Register.find(params[:id]))
        render json: { register: register.description }, status: :ok
      rescue StandardError
        render json: { errors: 'Registro não cadastrado!' }, status: :unprocessable_entity
      end

      def create
        register = @company.registers.build(params_register)
        if register.save
          new_register = RegisterPresenter.new(register)
          render json: { register: new_register.description }, status: :created
        else
          render json: { errors: register.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        register = Register.find(params[:id])

        if register.update(params_register)
          render json: { register: register }, status: :ok
        else
          render json: { errors: register.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        register = Register.find(params[:id])
        head :not_found if register.destroy
      rescue StandardError
        head :unprocessable_entity
      end

      private

      def set_company
        @company = current_user.company
      end

      def params_register
        params.require(:register).permit(:name, :birthday, :cpf, :rg, :accession_at, :plan, :status)
      end
    end
  end
end
