# frozen_string_literal: true

require "spec_helper"

RSpec.describe RunApi::IdeogramV3::Resources::EditImage do
  let(:http) { instance_double(RunApi::Core::HttpClient) }
  let(:edit_image) { described_class.new(http) }
  let(:endpoint) { "/api/v1/ideogram_v3/edit_image" }

  describe "#create" do
    it "POSTs to the correct endpoint with source_image_url and mask_url" do
      params = {
        model: "ideogram-v3-edit",
        prompt: "Cowboy hat",
        source_image_url: "https://x/a.png",
        mask_url: "https://x/m.png",
        output_count: 2
      }
      expect(http).to receive(:request).with(:post, endpoint, body: params).and_return("id" => "task-1")

      result = edit_image.create(**params)
      expect(result.id).to eq("task-1")
    end

    it "POSTs character edit params with reference images" do
      params = {
        model: "ideogram-v3-character-edit",
        prompt: "Smile",
        source_image_url: "https://x/a.png",
        mask_url: "https://x/m.png",
        reference_image_urls: ["https://x/ref.webp"],
        output_count: 2
      }
      expect(http).to receive(:request).with(:post, endpoint, body: params).and_return("id" => "task-character-edit")

      result = edit_image.create(**params)
      expect(result.id).to eq("task-character-edit")
    end
  end
end
