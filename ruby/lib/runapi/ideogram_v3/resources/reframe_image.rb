# frozen_string_literal: true

module RunApi
  module IdeogramV3
    module Resources
      # Reframe an input image (model: ideogram-v3-reframe).
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
          model = param(params, :model)
          raise Core::ValidationError, "model is required" unless model
          unless model == Types::REFRAME_MODEL
            raise Core::ValidationError, "Invalid model: #{model}. Must be #{Types::REFRAME_MODEL}"
          end

          raise Core::ValidationError, "source_image_url is required" unless param(params, :source_image_url)
          raise Core::ValidationError, "aspect_ratio is required" unless param(params, :aspect_ratio)

          validate_optional!(params, :aspect_ratio, Types::ASPECT_RATIOS)
          validate_optional!(params, :rendering_speed, Types::RENDERING_SPEEDS)
          validate_optional!(params, :style, Types::STYLES)
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
