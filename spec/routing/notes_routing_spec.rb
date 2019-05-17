require "rails_helper"

RSpec.describe NotesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/people/1/notes").to route_to("notes#index", person_id: "1")
    end

    it "routes to #new" do
      expect(:get => "/people/1/notes/new").to route_to("notes#new", person_id: "1")
    end

    it "routes to #show" do
      expect(:get => "/people/1/notes/1").to route_to("notes#show", :id => "1", person_id: "1")
    end

    it "routes to #edit" do
      expect(:get => "/people/1/notes/1/edit").to route_to("notes#edit", :id => "1", person_id: "1")
    end


    it "routes to #create" do
      expect(:post => "/people/1/notes").to route_to("notes#create", person_id: "1", person_id: "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/people/1/notes/1").to route_to("notes#update", :id => "1", person_id: "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/people/1/notes/1").to route_to("notes#update", :id => "1", person_id: "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/people/1/notes/1").to route_to("notes#destroy", :id => "1", person_id: "1")
    end
  end
end
