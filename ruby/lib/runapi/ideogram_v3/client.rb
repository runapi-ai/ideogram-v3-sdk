# frozen_string_literal: true

module RunApi
  module IdeogramV3
    # Ideogram V3 image generation API client.
    #
    # @example
    #   client = RunApi::IdeogramV3::Client.new(api_key: "your-api-key")
    #   result = client.generations.run(
    #     model: "ideogram-v3-text-to-image",
    #     prompt: "A cinematic lakeside at twilight"
    #   )
    class Client
      # @return [Resources::Generations] Text-to-image operations.
      # @return [Resources::Edits] Inpaint-with-mask operations.
      # @return [Resources::Remixes] Image remix operations.
      attr_reader :generations, :edits, :remixes

      def initialize(api_key: nil, **options)
        @api_key = Core::Auth.resolve_api_key(api_key)

        client_options = Core::ClientOptions.new(api_key: @api_key, **options)
        http = client_options.http_client || Core::HttpClient.new(client_options)
        @generations = Resources::Generations.new(http)
        @edits = Resources::Edits.new(http)
        @remixes = Resources::Remixes.new(http)
      end
    end
  end
end
