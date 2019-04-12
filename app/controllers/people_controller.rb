class PeopleController < ApplicationController
  autocomplete :person, :name, :display_value => :autocomplete_name

  def index
    @people = Person.all
  end

  def versions_index
    @person = Person.find( params[:id] )
  end

  def versions_show
    @person = Person.find( params[:id] )
    @person.revert_to( params[:version].to_i )
    puts "\n\n#{params[:version]} :: #{@person.version}\n\n"
  end

  def show
    @person = Person.find( params[:id] )
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

  def update
    @person = Person.find( params[:id] )

    respond_to do |format|
      if @person.update_attributes(person_params)
        format.html { redirect_to(@person, :notice => 'Person was successfully updated.') }
        format.json  { render :json => @person, :status => :ok }
      else
        format.json { render :json => @person.errors.to_a, :status => :unprocessable_entity }
      end
    end
  end

  def update_mother
    @person = Person.find(person_params)

    respond_to do |format|
      if @person.update_attributes( params[:person] )
        format.html { render :partial => "person", :locals => { :person => @person.mother }, :status => :ok }
      else
        format.json { render :json => @person.errors.to_a, :status => :unprocessable_entity }
      end
    end
  end

  def update_father
    @person = Person.find( params[:id] )

    respond_to do |format|
      if @person.update_attributes(person_params)
        format.html { render :partial => "person", :locals => { :person => @person.father }, :status => :ok }
      else
        format.json { render :json => @person.errors.to_a, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @person = Person.find( params[:id] )
    @person.destroy

    respond_to do |format|
      format.html { redirect_to( people_url ) }
    end
  end

  private
    def person_params
      params.require(:person).permit(
        :name, :gender, :father_id, :mother_id, :bio, :date_of_birth, :date_of_death
      )
    end

end
