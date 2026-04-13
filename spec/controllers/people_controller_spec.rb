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

  describe "POST #update_tree" do
    let!(:father) { create(:person, name: 'John Doe', gender: 'male') }
    let!(:mother) { create(:person, name: 'Jane Doe', gender: 'female') }
    let!(:child) { create(:person, name: 'Bob Doe', gender: 'male') }

    before do
      child.parentship.update!(father: father, mother: mother)
      father.partnerships.create!(partner: mother)
    end

    it "persists chart data and returns updated nodes" do
      post :update_tree, params: {
        nodes: [
          {
            id: father.id.to_s,
            data: { gender: 'M', 'first name' => 'John', 'last name' => 'Doe Updated' },
            rels: { spouses: [mother.id.to_s], children: [child.id.to_s] }
          },
          {
            id: mother.id.to_s,
            data: { gender: 'F', 'first name' => 'Jane', 'last name' => 'Doe' },
            rels: { spouses: [father.id.to_s], children: [child.id.to_s] }
          },
          {
            id: child.id.to_s,
            data: { gender: 'M', 'first name' => 'Bob', 'last name' => 'Doe' },
            rels: { parents: [father.id.to_s, mother.id.to_s] }
          }
        ]
      }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['ok']).to eq(true)
      expect(body['nodes']).to be_an(Array)
      father_node = body['nodes'].find { |n| n['id'] == father.id.to_s }
      expect(father_node['data']['name']).to eq('John Doe Updated')
    end
  end

  describe "GET #family_chart" do
    let!(:father) { create(:person, name: 'John Doe', gender: 'male') }
    let!(:mother) { create(:person, name: 'Jane Doe', gender: 'female') }
    let!(:child) { create(:person, name: 'Bob Doe', gender: 'male') }

    before do
      child.parentship.update!(father: father, mother: mother)
      father.partnerships.create!(partner: mother)
    end

    it "returns family-chart compatible json nodes" do
      get :family_chart, params: { format: :json }

      expect(response).to be_successful
      payload = JSON.parse(response.body)
      child_node = payload.find { |node| node['id'] == child.id.to_s }

      expect(child_node).not_to be_nil
      expect(child_node['data']['gender']).to eq('M')
      expect(child_node['rels']['parents']).to contain_exactly(father.id.to_s, mother.id.to_s)
    end

    it "optionally returns connector data" do
      get :family_chart, params: { format: :json, with_connectors: true }

      expect(response).to be_successful
      payload = JSON.parse(response.body)
      expect(payload['nodes']).to be_an(Array)
      expect(payload['connectors']).to be_an(Array)
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
