class ParentshipsController < ApplicationController
  before_action :set_parentship, only: [:update, :destroy]

  def update
    respond_to do |format|
      if @parentship.update(parentship_params)
        format.html { redirect_to @parentship, notice: 'parentship was successfully updated.' }
        format.json { render json: { message: 'updated' }, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @parentship.errors, status: :unprocessable_entity }
      end
    end
  end
  def destroy
    @parentship.destroy
    respond_to do |format|
      format.html { redirect_to parentships_url, notice: 'parentship was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parentship
      @parentship = Parentship.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def parentship_params
      params.require(:parentship).permit(:person_id, :father_id, :mother_id)
    end
end
