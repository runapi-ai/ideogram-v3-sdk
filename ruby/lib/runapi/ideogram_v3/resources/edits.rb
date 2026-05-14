# frozen_string_literal: true

module RunApi
  module IdeogramV3
    module Resources
      # Inpaint with mask (model: ideogram-v3-edit).
      class Edits
        include RunApi::Core::ResourceHelpers

        ENDPOINT = "/api/v1/ideogram_v3/edits"
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
          unless model == Types::EDIT_MODEL
            raise Core::ValidationError, "Invalid model: #{model}. Must be #{Types::EDIT_MODEL}"
          end

          prompt = param(params, :prompt)
          raise Core::ValidationError, "prompt is required" unless prompt.is_a?(String) && !prompt.empty?
          if prompt.length > PROMPT_MAX_LENGTH
            raise Core::ValidationError, "prompt must be at most #{PROMPT_MAX_LENGTH} characters"
          end

          raise Core::ValidationError, "image_url is required" unless param(params, :image_url)
          raise Core::ValidationError, "mask_url is required" unless param(params, :mask_url)

          validate_optional!(params, :rendering_speed, Types::RENDERING_SPEEDS)
        end
      end
    end
  end
end
