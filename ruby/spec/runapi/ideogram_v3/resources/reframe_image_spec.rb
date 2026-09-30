# frozen_string_literal: true

require "spec_helper"

RSpec.describe RunApi::IdeogramV3::Resources::ReframeImage do
  let(:http) { instance_double(RunApi::Core::HttpClient) }
  let(:reframe_image) { described_class.new(http) }
  let(:endpoint) { "/api/v1/ideogram_v3/reframe_image" }

  describe "#create" do
    it "POSTs to the correct endpoint with reframe params" do
      params = {
        model: "ideogram-v3-reframe",
        source_image_url: "https://x/source.png",
        aspect_ratio: "3:4",
        rendering_speed: "quality"
      }
      expect(http).to receive(:request).with(:post, endpoint, body: params).and_return("id" => "task-reframe")

      result = reframe_image.create(**params)
      expect(result.id).to eq("task-reframe")
    end
  end

  describe "#get" do
    it "GETs the correct endpoint" do
      expect(http).to receive(:request).with(:get, "#{endpoint}/task-1")
        .and_return("id" => "task-1", "status" => "completed")

      result = reframe_image.get("task-1")
      expect(result.status).to eq("completed")
    end
  end
end
