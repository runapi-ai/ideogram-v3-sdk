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
  end
end
