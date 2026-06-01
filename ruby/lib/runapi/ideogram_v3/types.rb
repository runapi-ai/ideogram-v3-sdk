# frozen_string_literal: true

module RunApi
  module IdeogramV3
    module Types
      GENERATION_MODEL = "ideogram-v3-text-to-image"
      EDIT_MODEL = "ideogram-v3-edit"
      REMIX_MODEL = "ideogram-v3-remix"
      CHARACTER_MODEL = "ideogram-v3-character"
      CHARACTER_EDIT_MODEL = "ideogram-v3-character-edit"
      CHARACTER_REMIX_MODEL = "ideogram-v3-character-remix"
      REFRAME_MODEL = "ideogram-v3-reframe"

      RENDERING_SPEEDS = %w[turbo balanced quality].freeze
      STYLES = %w[auto general realistic design].freeze
      CHARACTER_STYLES = %w[auto realistic fiction].freeze
      ASPECT_RATIOS = %w[1:1 3:4 9:16 4:3 16:9].freeze
      OUTPUT_COUNTS = [1, 2, 3, 4].freeze

      class Image < RunApi::Core::BaseModel
        optional :url, String
      end

      class IdeogramResponse < RunApi::Core::TaskResponse
        required :id, String
        optional :status, String, enum: -> { RunApi::Core::TaskResponse::Status::ALL }
        optional :images, [-> { Image }]
        optional :error, String
      end

      # Narrowed response returned by `run()` once polling sees `status: "completed"`.
      class CompletedIdeogramResponse < IdeogramResponse
        required :images, [-> { Image }]
      end
    end
  end
end
