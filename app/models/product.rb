class Product < ApplicationRecord
  has_many :movements, dependent: :destroy
  validates :name, presence: true
  validates :reference, presence: true

  def quantity
    total = 0
    self.movements.each do |movement|
      if movement.movement_type == Movement::MOVEMENT_TYPES[:add]
        total += movement.quantity
      else
        total -= movement.quantity
      end
    end
    return total
  end
end

