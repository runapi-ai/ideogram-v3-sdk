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
          unless [Types::GENERATION_MODEL, Types::CHARACTER_MODEL].include?(model)
            raise Core::ValidationError, "Invalid model: #{model}. Must be #{Types::GENERATION_MODEL} or #{Types::CHARACTER_MODEL}"
          end

          prompt = param(params, :prompt)
          raise Core::ValidationError, "prompt is required" unless prompt.is_a?(String) && !prompt.empty?
          if prompt.length > PROMPT_MAX_LENGTH
            raise Core::ValidationError, "prompt must be at most #{PROMPT_MAX_LENGTH} characters"
          end

          validate_optional!(params, :rendering_speed, Types::RENDERING_SPEEDS)
          style_values = (model == Types::CHARACTER_MODEL) ? Types::CHARACTER_STYLES : Types::STYLES
          validate_optional!(params, :style, style_values)
          validate_optional!(params, :aspect_ratio, Types::ASPECT_RATIOS)
          validate_character_refs!(params, model)
          validate_output_count!(params)
        end

        def validate_character_refs!(params, model)
          refs = param(params, :reference_image_urls)
          if model == Types::CHARACTER_MODEL
            raise Core::ValidationError, "reference_image_urls is required" unless refs.is_a?(Array) && refs.any?
          elsif refs
            raise Core::ValidationError, "reference_image_urls is not supported for #{model}"
          end
        end

        def validate_output_count!(params)
          output_count = param(params, :output_count)
          return unless output_count
          return if Types::OUTPUT_COUNTS.include?(output_count)

          raise Core::ValidationError, "Invalid output_count: #{output_count}. Must be one of: #{Types::OUTPUT_COUNTS.join(", ")}"
        end
      end
    end
  end
end
