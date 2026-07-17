# frozen_string_literal: true

module RunApi
  module IdeogramV3
    module Resources
      # Creates a variation of a source image guided by a new text prompt.
      class RemixImage
        include RunApi::Core::ResourceHelpers

        ENDPOINT = "/api/v1/ideogram_v3/remix_image"
        RESPONSE_CLASS = Types::IdeogramResponse
        COMPLETED_RESPONSE_CLASS = Types::CompletedIdeogramResponse
        PROMPT_MAX_LENGTH = 5000
        STRENGTH_MIN = 0.01
        CHARACTER_REMIX_STRENGTH_MIN = 0.1
        STRENGTH_MAX = 1.0

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
          validate_contract!(CONTRACT["remix-image"], params)
          model = param(params, :model)

          prompt = param(params, :prompt)
          raise Core::ValidationError, "prompt is required" unless prompt.is_a?(String) && !prompt.empty?
          if prompt.length > PROMPT_MAX_LENGTH
            raise Core::ValidationError, "prompt must be at most #{PROMPT_MAX_LENGTH} characters"
          end

          validate_character_fields!(params, model)

          if (strength = param(params, :strength))
            numeric = Float(strength, exception: false)
            min = (model == Types::CHARACTER_REMIX_MODEL) ? CHARACTER_REMIX_STRENGTH_MIN : STRENGTH_MIN
            if numeric.nil? || numeric < min || numeric > STRENGTH_MAX
              raise Core::ValidationError, "strength must be between #{min} and #{STRENGTH_MAX}"
            end
          end
        end

        def validate_character_fields!(params, model)
          refs = param(params, :reference_image_urls)
          if model == Types::CHARACTER_REMIX_MODEL
            raise Core::ValidationError, "reference_image_urls is required" unless refs.is_a?(Array) && refs.any?
          elsif refs || param(params, :style_reference_image_urls) || param(params, :reference_mask_urls)
            raise Core::ValidationError, "character remix fields are not supported for #{model}"
          end
        end
      end
    end
  end
end
