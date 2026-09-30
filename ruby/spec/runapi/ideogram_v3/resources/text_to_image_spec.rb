# frozen_string_literal: true

require "spec_helper"

RSpec.describe RunApi::IdeogramV3::Resources::TextToImage do
  let(:http) { instance_double(RunApi::Core::HttpClient) }
  let(:text_to_image) { described_class.new(http) }
  let(:endpoint) { "/api/v1/ideogram_v3/text_to_image" }

  describe "#create" do
    it "POSTs to the correct endpoint with text-to-image params" do
      params = {
        model: "ideogram-v3-text-to-image",
        prompt: "A lakeside at twilight",
        rendering_speed: "balanced",
        aspect_ratio: "1:1",
        output_count: 2
      }
      expect(http).to receive(:request).with(:post, endpoint, body: params).and_return("id" => "task-1")

      result = text_to_image.create(**params)
      expect(result).to be_a(RunApi::IdeogramV3::Types::IdeogramResponse)
      expect(result.id).to eq("task-1")
    end

    it "POSTs character params with reference images" do
      params = {
        model: "ideogram-v3-character",
        prompt: "A character in a garden",
        reference_image_urls: ["https://x/ref.webp"],
        style: "fiction",
        output_count: 2
      }
      expect(http).to receive(:request).with(:post, endpoint, body: params).and_return("id" => "task-character")

      result = text_to_image.create(**params)
      expect(result.id).to eq("task-character")
    end
  end

  describe "#get" do
    it "GETs the correct endpoint" do
      expect(http).to receive(:request).with(:get, "#{endpoint}/task-1")
        .and_return("id" => "task-1", "status" => "completed")

      result = text_to_image.get("task-1")
      expect(result.status).to eq("completed")
    end
  end
end
