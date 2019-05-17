require 'rails_helper'

RSpec.describe NotesController, type: :controller do

  let!(:person) { create(:person) }
  let!(:note)   { create(:note, person: person) }

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: { person_id: person }
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: {person_id: person, id: note.to_param}
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {person_id: person}
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: {person_id: person, id: note.to_param}
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Note" do
        expect {
          post :create, params: {person_id: person, note: attributes_for(:note)}
        }.to change(Note, :count).by(1)
      end

      it "redirects to the created note" do
        post :create, params: {person_id: person, note: attributes_for(:note)}
        expect(response).to redirect_to(person)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {person_id: person, note: attributes_for(:note)}
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested note" do
        put :update, params: {person_id: person, id: note.to_param, note: attributes_for(:note)}
        note.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the note" do
        put :update, params: {person_id: person, id: note.to_param, note: attributes_for(:note)}
        expect(response).to redirect_to(person)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {person_id: person, id: note.to_param, note: attributes_for(:note)}
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested note" do
      expect {
        delete :destroy, params: {person_id: person, id: note.to_param}
      }.to change(Note, :count).by(-1)
    end

    it "redirects to the notes list" do
      delete :destroy, params: {person_id: person, id: note.to_param}
      expect(response).to redirect_to(person)
    end
  end

end
