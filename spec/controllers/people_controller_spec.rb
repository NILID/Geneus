require 'rails_helper'

RSpec.describe PeopleController, type: :controller do

  let!(:person) { create(:person) }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: {id: person}
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: {id: person}
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Person" do
        expect {
          post :create, params: { person: attributes_for(:person) }
        }.to change(Person, :count).by(1)
      end

      it "redirects to the created person" do
        post :create, params: {person: attributes_for(:person)}
        expect(response).to redirect_to(Person.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {person: attributes_for(:person, gender: nil)}
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested person" do
        put :update, params: {id: person.to_param, person: new_attributes}
        person.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the person" do
        put :update, params: {id: person.to_param, person: attributes_for(:person)}
        expect(response).to redirect_to(person)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {id: person.to_param, person: attributes_for(:person, gender: nil)}
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested person" do
      expect {
        delete :destroy, params: {id: person.to_param}
      }.to change(Person, :count).by(-1)
    end

    it "redirects to the people list" do
      delete :destroy, params: {id: person.to_param}
      expect(response).to redirect_to(people_url)
    end
  end

end
