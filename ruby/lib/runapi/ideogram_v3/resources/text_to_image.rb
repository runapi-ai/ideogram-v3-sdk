# frozen_string_literal: true

module RunApi
  module IdeogramV3
    module Resources
      # Generates images from text with configurable speed, style, and aspect ratio.
      class TextToImage
        include RunApi::Core::ResourceHelpers

        ENDPOINT = "/api/v1/ideogram_v3/text_to_image"
        RESPONSE_CLASS = Types::IdeogramResponse
        COMPLETED_RESPONSE_CLASS = Types::CompletedIdeogramResponse
        PROMPT_MAX_LENGTH = 5000

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
          validate_contract!(CONTRACT["text-to-image"], params)
          model = param(params, :model)

          prompt = param(params, :prompt)
          raise Core::ValidationError, "prompt is required" unless prompt.is_a?(String) && !prompt.empty?
          if prompt.length > PROMPT_MAX_LENGTH
            raise Core::ValidationError, "prompt must be at most #{PROMPT_MAX_LENGTH} characters"
          end

          validate_character_refs!(params, model)
        end

        def validate_character_refs!(params, model)
          refs = param(params, :reference_image_urls)
          if model == Types::CHARACTER_MODEL
            raise Core::ValidationError, "reference_image_urls is required" unless refs.is_a?(Array) && refs.any?
          elsif refs
            raise Core::ValidationError, "reference_image_urls is not supported for #{model}"
          end
        end
      end
    end
  end
end
