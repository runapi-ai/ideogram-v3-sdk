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

    it "raises when source_image_url missing" do
      expect {
        edit_image.create(model: "ideogram-v3-edit", prompt: "hi", mask_url: "https://x/m.png")
      }.to raise_error(RunApi::Core::ValidationError, /source_image_url is required/)
    end

    it "raises when mask_url missing" do
      expect {
        edit_image.create(model: "ideogram-v3-edit", prompt: "hi", source_image_url: "https://x/a.png")
      }.to raise_error(RunApi::Core::ValidationError, /mask_url is required/)
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

    it "raises on invalid output_count" do
      expect {
        edit_image.create(
          model: "ideogram-v3-edit",
          prompt: "hi",
          source_image_url: "https://x/a.png",
          mask_url: "https://x/m.png",
          output_count: 7
        )
      }.to raise_error(RunApi::Core::ValidationError, /output_count must be one of: 1, 2, 3, 4/)
    end

    it "raises when character edit reference images are missing" do
      expect {
        edit_image.create(
          model: "ideogram-v3-character-edit",
          prompt: "hi",
          source_image_url: "https://x/a.png",
          mask_url: "https://x/m.png"
        )
      }.to raise_error(RunApi::Core::ValidationError, /reference_image_urls is required/)
    end
  end
end
