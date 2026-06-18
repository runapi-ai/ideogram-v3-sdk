"""Ideogram V3 model constants, enums, and response models."""

from __future__ import annotations

from runapi.core import BaseModel, TaskResponse, optional, required

GENERATION_MODEL = "ideogram-v3-text-to-image"
EDIT_MODEL = "ideogram-v3-edit"
REMIX_MODEL = "ideogram-v3-remix"
CHARACTER_MODEL = "ideogram-v3-character"
CHARACTER_EDIT_MODEL = "ideogram-v3-character-edit"
CHARACTER_REMIX_MODEL = "ideogram-v3-character-remix"
REFRAME_MODEL = "ideogram-v3-reframe"

RENDERING_SPEEDS = ["turbo", "balanced", "quality"]
STYLES = ["auto", "general", "realistic", "design"]
CHARACTER_STYLES = ["auto", "realistic", "fiction"]
ASPECT_RATIOS = ["1:1", "3:4", "9:16", "4:3", "16:9"]
OUTPUT_COUNTS = [1, 2, 3, 4]


class Image(BaseModel):
    url = optional(str)


class IdeogramResponse(TaskResponse):
    """Response for an Ideogram V3 image task."""

    id = required(str)
    status = optional(str, enum=lambda: TaskResponse.Status.ALL)
    images = optional([lambda: Image])
    error = optional(str)


class CompletedIdeogramResponse(IdeogramResponse):
    """Narrowed response from ``run()`` once polling observes ``status: completed``."""

    images = required([lambda: Image])
