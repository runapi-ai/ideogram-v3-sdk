# frozen_string_literal: true

require "runapi/ideogram_v3"

client = RunApi::IdeogramV3::Client.new(api_key: ENV.fetch("RUNAPI_API_KEY"))

task = client.generations.create(
  model: "ideogram-v3-text-to-image",
  prompt: "A cinematic lakeside at twilight with neon reeds",
  rendering_speed: "BALANCED",
  image_size: "square_hd"
)

puts "Task ID: #{task.id}"
