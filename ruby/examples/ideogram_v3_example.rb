# frozen_string_literal: true

require "runapi/ideogram_v3"

client = RunApi::IdeogramV3::Client.new(api_key: ENV.fetch("RUNAPI_API_KEY"))

task = client.text_to_image.create(
  model: "ideogram-v3-text-to-image",
  prompt: "A cinematic lakeside at twilight with neon reeds",
  rendering_speed: "balanced",
  aspect_ratio: "1:1"
)

puts "Task ID: #{task.id}"
