# frozen_string_literal: true

module RunApi
  module IdeogramV3
    # Ideogram V3 image generation API client.
    #
    # Supports text-to-image, inpaint editing, remix, and reframe operations.
    # Character model variants add character consistency from reference images.
    #
    # @example
    #   client = RunApi::IdeogramV3::Client.new(api_key: "your-api-key")
    #   result = client.text_to_image.run(
    #     model: "ideogram-v3-text-to-image",
    #     prompt: "A cinematic lakeside at twilight"
    #   )
    class Client < RunApi::Core::Client
      # @return [Resources::TextToImage] Text-to-image generation operations.
      attr_reader :text_to_image
      # @return [Resources::EditImage] Inpaint-with-mask editing operations.
      attr_reader :edit_image
      # @return [Resources::RemixImage] Prompt-guided image variation operations.
      attr_reader :remix_image
      # @return [Resources::ReframeImage] Aspect ratio reframing operations.
      attr_reader :reframe_image

      def initialize(api_key: nil, **options)
        super
        @text_to_image = Resources::TextToImage.new(http)
        @edit_image = Resources::EditImage.new(http)
        @remix_image = Resources::RemixImage.new(http)
        @reframe_image = Resources::ReframeImage.new(http)
      end
    end
  end
end
