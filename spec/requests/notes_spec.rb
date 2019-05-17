require 'rails_helper'

RSpec.describe "Notes", type: :request do
  let!(:person) { create(:person) }

  describe "GET /notes" do
    it "works! (now write some real specs)" do
      get people_notes_path(person)
      expect(response).to have_http_status(200)
    end
  end
end
