class PeopleController < ApplicationController
  before_action :set_person, only: %i[show edit update destroy versions update_father versions_show]

  def index
    @people = Person.all.includes(avatar_attachment: [:blob])
  end

  def list
    list = Person.tokens(params[:q])
    respond_to do |format|
      format.json { render json: list }
    end
  end

  def versions
  end

  def versions_show
    @person.revert_to( params[:version].to_i )
    puts "\n\n#{params[:version]} :: #{@person.version}\n\n"
  end

  def show
    @person = @person
    @father = @person.father
    @mother = @person.mother
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    respond_to do |format|
      if @person.save
        format.json { render :json => @person, :status => :ok }
        format.html { redirect_to @person }
      else
        format.json { render :json => @person.errors.to_a, :status => :unprocessable_entity }
        format.html { render :action => "new" }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @person.update_attributes(person_params)
        format.html { redirect_to(@person, :notice => 'Person was successfully updated.') }
        format.json  { render :json => @person, :status => :ok }
      else
        format.html { render :edit }
        format.json { render :json => @person.errors.to_a, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @person.destroy

    respond_to do |format|
      format.html { redirect_to( people_url ) }
    end
  end

  private
    def set_person
      @person = Person.find(params[:id])
    end

    def person_params
      params.require(:person).permit(
        :name,
        :gender,
        :bio,
        :date_of_birth,
        :date_of_death,
        :location_of_birth,
        :location_of_death,
        :avatar,
        { parentship_attributes: [:id, :father_id, :mother_id] },
        partner_ids: []
      )
    end
end
