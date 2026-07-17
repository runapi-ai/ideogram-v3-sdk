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

        def run(options: nil, **params)
          task = create(options: options, **params)
          poll_until_complete { get(task.id, options: options) }
        end

        def create(options: nil, **params)
          params = compact_params(params)
          validate_params!(params)
          request(:post, ENDPOINT, body: params, options: options)
        end

        def get(id, options: nil)
          request(:get, "#{ENDPOINT}/#{id}", options: options)
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
