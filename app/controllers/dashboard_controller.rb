class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @latest_movements = Movement.last(10)
    @top_products = Product.joins(:movements).where(movements: {movement_type: Movement::MOVEMENT_TYPES[:add]}).group(:id).order("SUM(movements.quantity) DESC").limit(5)
  end
end
