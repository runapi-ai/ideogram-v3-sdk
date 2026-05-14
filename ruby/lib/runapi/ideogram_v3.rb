# frozen_string_literal: true

require "runapi/core"
require_relative "ideogram_v3/types"
require_relative "ideogram_v3/resources/generations"
require_relative "ideogram_v3/resources/edits"
require_relative "ideogram_v3/resources/remixes"
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
