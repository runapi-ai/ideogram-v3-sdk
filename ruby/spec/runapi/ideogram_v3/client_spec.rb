# frozen_string_literal: true

require "spec_helper"

RSpec.describe RunApi::IdeogramV3::Client do
  before do
    allow(ConnectionPool).to receive(:new).and_return(instance_double(ConnectionPool))
  end

  after { RunApi.api_key = nil }

  it "accepts api_key as parameter" do
    client = described_class.new(api_key: "param-key")
    expect(client).to be_a(described_class)
  end

  it "falls back to global RunApi.api_key" do
    RunApi.api_key = "global-key"
    client = described_class.new
    expect(client).to be_a(described_class)
  end

  it "raises AuthenticationError without api_key" do
    expect { described_class.new }.to raise_error(RunApi::Core::AuthenticationError, /API key is required/)
  end

  it "exposes text_to_image, edit_image, remix_image, and reframe_image accessors" do
    client = described_class.new(api_key: "test-key")
    expect(client.text_to_image).to be_a(RunApi::IdeogramV3::Resources::TextToImage)
    expect(client.edit_image).to be_a(RunApi::IdeogramV3::Resources::EditImage)
    expect(client.remix_image).to be_a(RunApi::IdeogramV3::Resources::RemixImage)
    expect(client.reframe_image).to be_a(RunApi::IdeogramV3::Resources::ReframeImage)
  end
end
