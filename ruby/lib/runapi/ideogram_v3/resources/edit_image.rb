# frozen_string_literal: true

module RunApi
  module IdeogramV3
    module Resources
      # Inpaint editing using a mask to define the regenerated region.
      class EditImage
        include RunApi::Core::ResourceHelpers

        ENDPOINT = "/api/v1/ideogram_v3/edit_image"
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
          unless [Types::EDIT_MODEL, Types::CHARACTER_EDIT_MODEL].include?(model)
            raise Core::ValidationError, "Invalid model: #{model}. Must be #{Types::EDIT_MODEL} or #{Types::CHARACTER_EDIT_MODEL}"
          end

          prompt = param(params, :prompt)
          raise Core::ValidationError, "prompt is required" unless prompt.is_a?(String) && !prompt.empty?
          if prompt.length > PROMPT_MAX_LENGTH
            raise Core::ValidationError, "prompt must be at most #{PROMPT_MAX_LENGTH} characters"
          end

          raise Core::ValidationError, "source_image_url is required" unless param(params, :source_image_url)
          raise Core::ValidationError, "mask_url is required" unless param(params, :mask_url)

          validate_optional!(params, :rendering_speed, Types::RENDERING_SPEEDS)
          validate_character_fields!(params, model)
        end

        def validate_character_fields!(params, model)
          refs = param(params, :reference_image_urls)
          if model == Types::CHARACTER_EDIT_MODEL
            raise Core::ValidationError, "reference_image_urls is required" unless refs.is_a?(Array) && refs.any?
            validate_optional!(params, :style, Types::CHARACTER_STYLES)
          elsif refs || param(params, :style)
            raise Core::ValidationError, "character edit fields are not supported for #{model}"
          end
          validate_output_count!(params)
        end

        def validate_output_count!(params)
          return unless (output_count = param(params, :output_count))
          return if Types::OUTPUT_COUNTS.include?(output_count)

          raise Core::ValidationError, "Invalid output_count: #{output_count}. Must be one of: #{Types::OUTPUT_COUNTS.join(", ")}"
        end
      end
    end
  end
end
