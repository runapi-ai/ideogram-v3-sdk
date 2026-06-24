"""Ideogram V3 model constants, enums, and response models."""

from __future__ import annotations

from runapi.core import BaseModel, TaskResponse, optional, required

CHARACTER_MODEL = "ideogram-v3-character"
CHARACTER_EDIT_MODEL = "ideogram-v3-character-edit"
CHARACTER_REMIX_MODEL = "ideogram-v3-character-remix"


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
