# frozen_string_literal: true

module RunApi
  module IdeogramV3
    # Type definitions and constants for Ideogram V3.
    # Character model variants add character consistency from reference images.
    module Types
      CHARACTER_MODEL = "ideogram-v3-character"
      CHARACTER_EDIT_MODEL = "ideogram-v3-character-edit"
      CHARACTER_REMIX_MODEL = "ideogram-v3-character-remix"

      # A single generated image with its CDN URL.
      class Image < RunApi::Core::BaseModel
        optional :url, String
      end

      # Normalized response for all Ideogram V3 endpoints.
      # +images+ is populated once +status+ is +"completed"+.
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
