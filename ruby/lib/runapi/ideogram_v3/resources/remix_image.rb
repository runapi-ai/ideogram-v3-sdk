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
          model = param(params, :model)
          raise Core::ValidationError, "model is required" unless model
          unless [Types::REMIX_MODEL, Types::CHARACTER_REMIX_MODEL].include?(model)
            raise Core::ValidationError, "Invalid model: #{model}. Must be #{Types::REMIX_MODEL} or #{Types::CHARACTER_REMIX_MODEL}"
          end

          prompt = param(params, :prompt)
          raise Core::ValidationError, "prompt is required" unless prompt.is_a?(String) && !prompt.empty?
          if prompt.length > PROMPT_MAX_LENGTH
            raise Core::ValidationError, "prompt must be at most #{PROMPT_MAX_LENGTH} characters"
          end

          raise Core::ValidationError, "source_image_url is required" unless param(params, :source_image_url)

          validate_optional!(params, :rendering_speed, Types::RENDERING_SPEEDS)
          style_values = (model == Types::CHARACTER_REMIX_MODEL) ? Types::CHARACTER_STYLES : Types::STYLES
          validate_optional!(params, :style, style_values)
          validate_optional!(params, :aspect_ratio, Types::ASPECT_RATIOS)
          validate_character_fields!(params, model)

          if (output_count = param(params, :output_count))
            unless Types::OUTPUT_COUNTS.include?(output_count)
              raise Core::ValidationError, "Invalid output_count: #{output_count}. Must be one of: #{Types::OUTPUT_COUNTS.join(", ")}"
            end
          end

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
