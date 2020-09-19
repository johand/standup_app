require "rails_helper"

RSpec.describe StandupsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/standups").to route_to("standups#index")
    end

    it "routes to #new" do
      expect(get: "/standups/new").to route_to("standups#new")
    end

    it "routes to #show" do
      expect(get: "/standups/1").to route_to("standups#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/standups/1/edit").to route_to("standups#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/standups").to route_to("standups#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/standups/1").to route_to("standups#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/standups/1").to route_to("standups#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/standups/1").to route_to("standups#destroy", id: "1")
    end
  end
end
