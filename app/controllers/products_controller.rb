class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    # @products = Product.all
    @products = Product.order(params[:sort])   # Sustituye el Product.all -- el order ayuda a organizar los productos en orden alfabetico.
    if params[:query].present?
      @products = @products.where("name LIKE '%#{params[:query]}%'")     # Lenguaje SQL para buscar productos con el campo name
    else
      flash[:notice] =  "No se ha encontrado ningun producto"
    end
    respond_to do |format|
      format.html
      format.json
      format.xlsx{ 
        response.headers["Content-Disposition"] = 'attachment; filename= "Listado de productos.xlsx"'
      }
    end
  end  

  # GET /products/1 or /products/1.json
  def show
    @movements = @product.movements
    respond_to do |format|
      format.html
      format.json
      format.xlsx{ 
        response.headers["Content-Disposition"] = "attachment; filename= Movimiento de producto - #{@product.name} #{Time.now}.xlsx"
      }
    end
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json

  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def create_movement
    @product = Product.find(params[:id])
    @movement = Movement.new(movement_params)
    @movement.product_id = @product.id
    if @movement.save
      redirect_to @product, notice: "Se creó el movimento correctamente"
    else
      flash[:notice] =  "Ha ocurrido un error al crear el movimiento"  
      render :new_movement, status: :unprocessable_entity  
    end
  end  

  def new_movement
    @product = Product.find(params[:id])
    @movement = Movement.new
  end

  def edit_movement
    @product = Product.find(params[:id])
    @movement = Movement.find(params[:movement_id])
  end

  def update_movement
    @product = Product.find(params[:id])
    @movement = Movement.find(params[:movement_id])
    if @movement.update(movement_params)
      flash[:notice] = "Se editó el movimento correctamente"
      redirect_to @product
    else
      flash[:notice] =  "Ha ocurrido un error al editar el movimiento" 
    end   
  end

  def destroy_movement
    @movement = Movement.find(params[:movement_id])
    @movement.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def movement_params
    params.require(:movement).permit(:quantity, :movement_type, :comment)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:name, :reference, :description)
  end
end
