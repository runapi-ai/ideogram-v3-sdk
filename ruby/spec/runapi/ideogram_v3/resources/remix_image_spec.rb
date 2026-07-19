# frozen_string_literal: true

require "spec_helper"

RSpec.describe RunApi::IdeogramV3::Resources::RemixImage do
  let(:http) { instance_double(RunApi::Core::HttpClient) }
  let(:remix_image) { described_class.new(http) }
  let(:endpoint) { "/api/v1/ideogram_v3/remix_image" }

  describe "#create" do
    it "POSTs to the correct endpoint with output_count and strength" do
      params = {
        model: "ideogram-v3-remix",
        prompt: "Remix",
        source_image_url: "https://x/i.png",
        output_count: 2,
        strength: 0.8
      }
      expect(http).to receive(:request).with(:post, endpoint, body: params).and_return("id" => "task-1")

      result = remix_image.create(**params)
      expect(result.id).to eq("task-1")
    end

    it "raises when source_image_url missing" do
      expect {
        remix_image.create(model: "ideogram-v3-remix", prompt: "hi")
      }.to raise_error(RunApi::Core::ValidationError, /source_image_url is required/)
    end

    it "raises on invalid output_count" do
      expect {
        remix_image.create(model: "ideogram-v3-remix", prompt: "hi", source_image_url: "https://x/i.png", output_count: 7)
      }.to raise_error(RunApi::Core::ValidationError, /output_count must be one of: 1, 2, 3, 4/)
    end

    it "raises on strength out of range" do
      expect {
        remix_image.create(model: "ideogram-v3-remix", prompt: "hi", source_image_url: "https://x/i.png", strength: 1.5)
      }.to raise_error(RunApi::Core::ValidationError, /strength must be between/)
    end

    it "POSTs character remix params with reference images" do
      params = {
        model: "ideogram-v3-character-remix",
        prompt: "Restyle",
        source_image_url: "https://x/i.png",
        reference_image_urls: ["https://x/character.webp"],
        style_reference_image_urls: ["https://x/style.webp"],
        reference_mask_urls: ["https://x/mask.webp"]
      }
      expect(http).to receive(:request).with(:post, endpoint, body: params).and_return("id" => "task-character-remix")

      result = remix_image.create(**params)
      expect(result.id).to eq("task-character-remix")
    end

    it "raises when character remix reference images are missing" do
      expect {
        remix_image.create(model: "ideogram-v3-character-remix", prompt: "hi", source_image_url: "https://x/i.png")
      }.to raise_error(RunApi::Core::ValidationError, /reference_image_urls is required/)
    end

    it "raises when character remix strength is below the character minimum" do
      expect {
        remix_image.create(
          model: "ideogram-v3-character-remix",
          prompt: "hi",
          source_image_url: "https://x/i.png",
          reference_image_urls: ["https://x/character.webp"],
          strength: 0.05
        )
      }.to raise_error(RunApi::Core::ValidationError, /strength must be between 0.1 and 1.0/)
    end
  end
end
