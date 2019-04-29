class PartnershipsController < ApplicationController
  def create
    params[:partnership].delete(:partner_name)
    @partnership = Partnership.new(partnership_params)
    @person = Person.find( partnership_params[:person_id] )
    respond_to do |format|
      if @partnership.save
        format.html do
          render :partial => 'people/partnership',
                 :locals  => { partnership: @partnership, person: @person },
                 :layout  => false,
                 :status  => :ok
        end
      else
        format.json  { render :json => @partnership.errors.to_a, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @partnership = Partnership.find( params[:id] )

    respond_to do |format|
      if @partnership.destroy
        format.js
      else
        format.js
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def partnership_params
      params.require(:partnership).permit(:person_id, :partner_id, :date_started, :date_ended, :nature)
    end

end
