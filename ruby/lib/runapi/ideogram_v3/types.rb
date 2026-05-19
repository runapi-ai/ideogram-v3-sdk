# frozen_string_literal: true

module RunApi
  module IdeogramV3
    module Types
      GENERATION_MODEL = "ideogram-v3-text-to-image"
      EDIT_MODEL = "ideogram-v3-edit"
      REMIX_MODEL = "ideogram-v3-remix"

      RENDERING_SPEEDS = %w[TURBO BALANCED QUALITY].freeze
      STYLES = %w[AUTO GENERAL REALISTIC DESIGN].freeze
      IMAGE_SIZES = %w[
        square square_hd portrait_4_3 portrait_16_9 landscape_4_3 landscape_16_9
      ].freeze
      NUM_IMAGES = %w[1 2 3 4].freeze

      class Image < RunApi::Core::BaseModel
        optional :url, String
      end

      class IdeogramResponse < RunApi::Core::TaskResponse
        required :id, String
        optional :status, String, enum: -> { RunApi::Core::TaskResponse::Status::ALL }
        optional :images, [ -> { Image } ]
        optional :error, String
      end

      # Narrowed response returned by `run()` once polling sees `status: "completed"`.
      class CompletedIdeogramResponse < IdeogramResponse
        required :images, [ -> { Image } ]
      end
    end
  end
end
