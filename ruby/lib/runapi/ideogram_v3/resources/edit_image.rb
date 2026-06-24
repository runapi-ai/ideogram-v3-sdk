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
          validate_contract!(CONTRACT["edit-image"], params)
          model = param(params, :model)

          prompt = param(params, :prompt)
          raise Core::ValidationError, "prompt is required" unless prompt.is_a?(String) && !prompt.empty?
          if prompt.length > PROMPT_MAX_LENGTH
            raise Core::ValidationError, "prompt must be at most #{PROMPT_MAX_LENGTH} characters"
          end

          raise Core::ValidationError, "mask_url is required" unless param(params, :mask_url)

          validate_character_fields!(params, model)
        end

        def validate_character_fields!(params, model)
          refs = param(params, :reference_image_urls)
          if model == Types::CHARACTER_EDIT_MODEL
            raise Core::ValidationError, "reference_image_urls is required" unless refs.is_a?(Array) && refs.any?
          elsif refs || param(params, :style)
            raise Core::ValidationError, "character edit fields are not supported for #{model}"
          end
        end
      end
    end
  end
end
