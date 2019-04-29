class ChildrenController < ApplicationController
  def create
    @person = Person.find( params[:person_id] )
    @child  = Person.find( params[:child][:child_id] )
    @person.add_child( @child )
    respond_to do |format|
      if @person.save
        format.html do
          render :partial => 'people/child',
                 :locals  => { child: @child, person: @person },
                 :layout  => false,
                 :status  => :ok
        end
      else
        format.json { render :json => @person.errors.to_a, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @person = Person.find( params[:person_id] )
    @child  = Person.find( params[:id] )
    @person.remove_child( @child )

    respond_to do |format|
      if @person.save
        format.js
        format.html { redirect_to @person }
      else
        format.json { render :json => @person.errors.to_a, :status => :unprocessable_entity }
      end
    end
  end
end
