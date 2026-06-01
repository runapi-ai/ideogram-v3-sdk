# frozen_string_literal: true

module RunApi
  module IdeogramV3
    # Ideogram V3 image generation API client.
    #
    # @example
    #   client = RunApi::IdeogramV3::Client.new(api_key: "your-api-key")
    #   result = client.text_to_image.run(
    #     model: "ideogram-v3-text-to-image",
    #     prompt: "A cinematic lakeside at twilight"
    #   )
    class Client
      # @return [Resources::TextToImage] Text-to-image operations.
      # @return [Resources::EditImage] Inpaint-with-mask operations.
      # @return [Resources::RemixImage] Image remix operations.
      # @return [Resources::ReframeImage] Image reframe operations.
      attr_reader :text_to_image, :edit_image, :remix_image, :reframe_image

      def initialize(api_key: nil, **options)
        @api_key = Core::Auth.resolve_api_key(api_key)

        client_options = Core::ClientOptions.new(api_key: @api_key, **options)
        http = client_options.http_client || Core::HttpClient.new(client_options)
        @text_to_image = Resources::TextToImage.new(http)
        @edit_image = Resources::EditImage.new(http)
        @remix_image = Resources::RemixImage.new(http)
        @reframe_image = Resources::ReframeImage.new(http)
      end
    end
  end
end
