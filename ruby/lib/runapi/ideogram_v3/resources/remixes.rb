# frozen_string_literal: true

module RunApi
  module IdeogramV3
    module Resources
      # Image remix (model: ideogram-v3-remix).
      class Remixes
        include RunApi::Core::ResourceHelpers

        ENDPOINT = "/api/v1/ideogram_v3/remixes"
        RESPONSE_CLASS = Types::IdeogramResponse
        COMPLETED_RESPONSE_CLASS = Types::CompletedIdeogramResponse
        PROMPT_MAX_LENGTH = 5000
        STRENGTH_MIN = 0.01
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
          unless model == Types::REMIX_MODEL
            raise Core::ValidationError, "Invalid model: #{model}. Must be #{Types::REMIX_MODEL}"
          end

          prompt = param(params, :prompt)
          raise Core::ValidationError, "prompt is required" unless prompt.is_a?(String) && !prompt.empty?
          if prompt.length > PROMPT_MAX_LENGTH
            raise Core::ValidationError, "prompt must be at most #{PROMPT_MAX_LENGTH} characters"
          end

          raise Core::ValidationError, "image_url is required" unless param(params, :image_url)

          validate_optional!(params, :rendering_speed, Types::RENDERING_SPEEDS)
          validate_optional!(params, :style, Types::STYLES)
          validate_optional!(params, :image_size, Types::IMAGE_SIZES)

          if (num_images = param(params, :num_images))
            unless Types::NUM_IMAGES.include?(num_images.to_s)
              raise Core::ValidationError, "Invalid num_images: #{num_images}. Must be one of: #{Types::NUM_IMAGES.join(", ")}"
            end
          end

          if (strength = param(params, :strength))
            numeric = Float(strength, exception: false)
            if numeric.nil? || numeric < STRENGTH_MIN || numeric > STRENGTH_MAX
              raise Core::ValidationError, "strength must be between #{STRENGTH_MIN} and #{STRENGTH_MAX}"
            end
          end
        end
      end
    end
  end
end
