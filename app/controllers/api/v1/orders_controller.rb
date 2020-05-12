module Api
  module V1
    class OrdersController < ApplicationController
      def index
        if params[:customer_id].present?
          @orders = Order.where(customer_id: params[:customer_id])
        else
          @orders = Order.all
        end

        render json: @orders
      end

      def create
        @order = Order.new(order_params)

        if @order.save
          render json: @order, status: 'Pending', customer_id: params[:customer_id]
        else
          render json: { message: "Unable to add order" }, status: :unprocessable_entity
        end
      end

      def show
        @order = Order.find(params[:id])

        render json: @order
      end

      def ship
        @order = Order.find(params[:id])

        @order.update(status: 'Shipped')

        render json: @order
      end

      private

        def order_params
          params.require(:order).permit(:status, :customer_id)
        end
    end
  end
end