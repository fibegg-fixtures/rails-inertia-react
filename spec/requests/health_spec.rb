require "rails_helper"

RSpec.describe "Health", type: :request do
  it "GET /up returns 200" do
    get "/up"
    expect(response).to have_http_status(:ok)
  end

  it "GET / renders the Inertia Home page" do
    get "/", headers: { "Accept" => "text/html" }
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("data-page")
  end
end
