class NotesController < ApplicationController
  before_action :set_person
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  def index
    @notes = @person.notes.all
  end

  def show; end

  def new
    @note = @person.notes.new
  end

  def edit
  end

  def create
    @note = @person.notes.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to @person, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @person, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to @person, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_person
      @person = Person.find(params[:person_id])
    end

    def set_note
      @note = @person.notes.find(params[:id])
    end

    def note_params
      params.require(:note).permit(:content, :person_id)
    end
end
