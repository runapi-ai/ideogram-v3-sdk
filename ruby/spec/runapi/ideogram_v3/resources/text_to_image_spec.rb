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

    it "raises when model is wrong" do
      expect {
        text_to_image.create(model: "ideogram-v3-edit", prompt: "hi")
      }.to raise_error(RunApi::Core::ValidationError, /model must be one of: ideogram-v3-character, ideogram-v3-text-to-image/)
    end

    it "raises when prompt missing" do
      expect {
        text_to_image.create(model: "ideogram-v3-text-to-image")
      }.to raise_error(RunApi::Core::ValidationError, /prompt is required/)
    end

    it "raises on invalid rendering_speed" do
      expect {
        text_to_image.create(model: "ideogram-v3-text-to-image", prompt: "hi", rendering_speed: "FAST")
      }.to raise_error(RunApi::Core::ValidationError, /rendering_speed must be one of: turbo, balanced, quality/)
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

    it "raises on invalid output_count" do
      expect {
        text_to_image.create(model: "ideogram-v3-text-to-image", prompt: "hi", output_count: 7)
      }.to raise_error(RunApi::Core::ValidationError, /output_count must be one of: 1, 2, 3, 4/)
    end

    it "raises when character reference images are missing" do
      expect {
        text_to_image.create(model: "ideogram-v3-character", prompt: "hi")
      }.to raise_error(RunApi::Core::ValidationError, /reference_image_urls is required/)
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
