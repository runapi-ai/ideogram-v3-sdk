# frozen_string_literal: true

module RunApi
  module IdeogramV3
    module Resources
      # Extends or crops an image to a new aspect ratio without regenerating content.
      class ReframeImage
        include RunApi::Core::ResourceHelpers

        ENDPOINT = "/api/v1/ideogram_v3/reframe_image"
        RESPONSE_CLASS = Types::IdeogramResponse
        COMPLETED_RESPONSE_CLASS = Types::CompletedIdeogramResponse

        def initialize(http)
          @http = http
        end

        def run(**params)
          task = create(**params)
          poll_until_complete { get(task.id) }
        end

        def create(**params)
          params = compact_params(params)
          validate_params!(params)
          request(:post, ENDPOINT, body: params)
        end

        def get(id)
          request(:get, "#{ENDPOINT}/#{id}")
        end

        private

        def validate_params!(params)
          validate_contract!(CONTRACT["reframe-image"], params)

          raise Core::ValidationError, "aspect_ratio is required" unless param(params, :aspect_ratio)
        end
      end
    end
  end
end
