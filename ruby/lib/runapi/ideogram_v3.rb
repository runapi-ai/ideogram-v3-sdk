# frozen_string_literal: true

require "runapi/core"
require_relative "ideogram_v3/types"
require_relative "ideogram_v3/resources/text_to_image"
require_relative "ideogram_v3/resources/edit_image"
require_relative "ideogram_v3/resources/remix_image"
require_relative "ideogram_v3/resources/reframe_image"
require_relative "ideogram_v3/client"

module RunApi
  module IdeogramV3
    AuthenticationError = RunApi::Core::AuthenticationError
    RateLimitError = RunApi::Core::RateLimitError
    InsufficientCreditsError = RunApi::Core::InsufficientCreditsError
    NotFoundError = RunApi::Core::NotFoundError
    ValidationError = RunApi::Core::ValidationError
    TaskFailedError = RunApi::Core::TaskFailedError
    TaskTimeoutError = RunApi::Core::TaskTimeoutError
  end
end
