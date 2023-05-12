class Movement < ApplicationRecord
  belongs_to :product
  MOVEMENT_TYPES = {add: 0, remove: 1}
  validates :quantity, presence: true, numericality: true
  validates :comment, presence: true

  def self.get_movement_types
    {
      "Agregar" => MOVEMENT_TYPES[:add],
      "Quitar" => MOVEMENT_TYPES[:remove]
    }
  end

  def movement_type_name
    return "Ingreso" if movement_type == MOVEMENT_TYPES[:add]
    return "Salida" if movement_type == MOVEMENT_TYPES[:remove]
    return "NA"
  end
end


