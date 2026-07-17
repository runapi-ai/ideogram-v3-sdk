"""Ideogram V3 reframe-image resource (model: ideogram-v3-reframe)."""

from __future__ import annotations

from typing import Any, Dict, Optional

from runapi.core import Resource, ValidationError, RequestOptions

from ..contract_gen import CONTRACT
from ..types import (
    CompletedIdeogramResponse,
    IdeogramResponse,
)


class ReframeImage(Resource):
    """Reframe a source image to a new aspect ratio with Ideogram V3."""

    ENDPOINT = "/api/v1/ideogram_v3/reframe_image"
    RESPONSE_CLASS = IdeogramResponse
    COMPLETED_RESPONSE_CLASS = CompletedIdeogramResponse

    def run(self, options: Optional[RequestOptions] = None, **params: Any) -> Any:
        """Create a reframe-image task and poll until it completes.

        Args:
            **params: Reframe-image parameters (model, source_image_url, aspect_ratio, ...).

        Returns:
            The completed (narrowed) response.
        """
        task = self.create(options=options, **params)
        return self._poll_until_complete(lambda: self.get(task.id, options=options))

    def create(self, options: Optional[RequestOptions] = None, **params: Any) -> Any:
        """Create a reframe-image task and return immediately with an ``id``.

        Args:
            **params: Reframe-image parameters (model, source_image_url, aspect_ratio, ...).

        Returns:
            The task creation result with an id.
        """
        compacted = self._compact_params(params)
        self._validate_params(compacted)
        return self._request("post", self.ENDPOINT, body=compacted, options=options)

    def get(self, id: str, options: Optional[RequestOptions] = None) -> Any:
        """Fetch the current status of a reframe-image task.

        Args:
            id: The task id.

        Returns:
            The current task status.
        """
        return self._request("get", f"{self.ENDPOINT}/{id}", options=options)

    def _validate_params(self, params: Dict[str, Any]) -> None:
        self._validate_contract(CONTRACT["reframe-image"], params)

        if not params.get("aspect_ratio"):
            raise ValidationError("aspect_ratio is required")
