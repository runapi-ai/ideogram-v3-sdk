import pytest

from runapi.core import config
from runapi.core.errors import AuthenticationError, ValidationError
from runapi.ideogram_v3 import IdeogramV3Client
from runapi.ideogram_v3.resources.edit_image import EditImage
from runapi.ideogram_v3.resources.reframe_image import ReframeImage
from runapi.ideogram_v3.resources.remix_image import RemixImage
from runapi.ideogram_v3.resources.text_to_image import TextToImage
from runapi.ideogram_v3.types import CompletedIdeogramResponse, IdeogramResponse


class FakeHttp:
    def __init__(self, *responses):
        self._responses = list(responses)
        self.calls = []

    def request(self, method, path, body=None, options=None):
        self.calls.append((method, path, body))
        if self._responses:
            return self._responses.pop(0)
        return {"id": "task_1", "status": "pending"}


@pytest.fixture(autouse=True)
def reset_config(monkeypatch):
    monkeypatch.delenv("RUNAPI_API_KEY", raising=False)
    monkeypatch.setattr(config, "api_key", None)
    yield


# --- auth -----------------------------------------------------------------


def test_accepts_api_key_parameter():
    assert isinstance(IdeogramV3Client(api_key="k", http_client=FakeHttp()), IdeogramV3Client)


def test_falls_back_to_global(monkeypatch):
    monkeypatch.setattr(config, "api_key", "global-key")
    assert isinstance(IdeogramV3Client(http_client=FakeHttp()), IdeogramV3Client)


def test_falls_back_to_env(monkeypatch):
    monkeypatch.setenv("RUNAPI_API_KEY", "env-key")
    assert isinstance(IdeogramV3Client(http_client=FakeHttp()), IdeogramV3Client)


def test_raises_without_api_key():
    with pytest.raises(AuthenticationError, match="API key is required"):
        IdeogramV3Client()


# --- injection / accessors ------------------------------------------------


def test_uses_injected_http_client():
    fake = FakeHttp()
    client = IdeogramV3Client(api_key="k", http_client=fake)
    assert client.text_to_image._http is fake
    assert client.edit_image._http is fake
    assert client.remix_image._http is fake
    assert client.reframe_image._http is fake


def test_exposes_resource_accessors():
    client = IdeogramV3Client(api_key="k", http_client=FakeHttp())
    assert isinstance(client.text_to_image, TextToImage)
    assert isinstance(client.edit_image, EditImage)
    assert isinstance(client.remix_image, RemixImage)
    assert isinstance(client.reframe_image, ReframeImage)


# --- request shapes -------------------------------------------------------


def test_text_to_image_create_posts_compacted_body():
    fake = FakeHttp({"id": "t1", "status": "pending"})
    client = IdeogramV3Client(api_key="k", http_client=fake)
    result = client.text_to_image.create(
        model="ideogram-v3-text-to-image",
        prompt="hello world",
        aspect_ratio="1:1",
        rendering_speed=None,
    )
    assert fake.calls == [
        (
            "post",
            "/api/v1/ideogram_v3/text_to_image",
            {"model": "ideogram-v3-text-to-image", "prompt": "hello world", "aspect_ratio": "1:1"},
        ),
    ]
    assert isinstance(result, IdeogramResponse)


def test_text_to_image_get_fetches_by_id():
    fake = FakeHttp({"id": "t1", "status": "processing"})
    client = IdeogramV3Client(api_key="k", http_client=fake)
    client.text_to_image.get("t1")
    assert fake.calls == [("get", "/api/v1/ideogram_v3/text_to_image/t1", None)]


def test_edit_image_create_posts_body():
    fake = FakeHttp({"id": "t1", "status": "pending"})
    client = IdeogramV3Client(api_key="k", http_client=fake)
    client.edit_image.create(
        model="ideogram-v3-edit",
        prompt="add aurora",
        source_image_url="https://x/a.png",
        mask_url="https://x/m.png",
    )
    assert fake.calls == [
        (
            "post",
            "/api/v1/ideogram_v3/edit_image",
            {
                "model": "ideogram-v3-edit",
                "prompt": "add aurora",
                "source_image_url": "https://x/a.png",
                "mask_url": "https://x/m.png",
            },
        ),
    ]


def test_remix_image_create_posts_body():
    fake = FakeHttp({"id": "t1", "status": "pending"})
    client = IdeogramV3Client(api_key="k", http_client=fake)
    client.remix_image.create(
        model="ideogram-v3-remix",
        prompt="remix it",
        source_image_url="https://x/a.png",
        strength=0.5,
    )
    assert fake.calls == [
        (
            "post",
            "/api/v1/ideogram_v3/remix_image",
            {
                "model": "ideogram-v3-remix",
                "prompt": "remix it",
                "source_image_url": "https://x/a.png",
                "strength": 0.5,
            },
        ),
    ]


def test_remix_image_get_fetches_by_id():
    fake = FakeHttp({"id": "t1", "status": "processing"})
    client = IdeogramV3Client(api_key="k", http_client=fake)
    client.remix_image.get("t1")
    assert fake.calls == [("get", "/api/v1/ideogram_v3/remix_image/t1", None)]


def test_reframe_image_create_posts_body():
    fake = FakeHttp({"id": "t1", "status": "pending"})
    client = IdeogramV3Client(api_key="k", http_client=fake)
    client.reframe_image.create(
        model="ideogram-v3-reframe",
        source_image_url="https://x/a.png",
        aspect_ratio="16:9",
    )
    assert fake.calls == [
        (
            "post",
            "/api/v1/ideogram_v3/reframe_image",
            {
                "model": "ideogram-v3-reframe",
                "source_image_url": "https://x/a.png",
                "aspect_ratio": "16:9",
            },
        ),
    ]


def test_reframe_image_get_fetches_by_id():
    fake = FakeHttp({"id": "t1", "status": "processing"})
    client = IdeogramV3Client(api_key="k", http_client=fake)
    client.reframe_image.get("t1")
    assert fake.calls == [("get", "/api/v1/ideogram_v3/reframe_image/t1", None)]


# --- run() narrowing ------------------------------------------------------


def test_text_to_image_run_narrows_completed_type():
    fake = FakeHttp(
        {"id": "t1", "status": "pending"},
        {"id": "t1", "status": "completed", "images": [{"url": "https://x/y.png"}]},
    )
    client = IdeogramV3Client(api_key="k", http_client=fake)
    result = client.text_to_image.run(
        model="ideogram-v3-text-to-image", prompt="a serene lake"
    )
    assert isinstance(result, CompletedIdeogramResponse)
    assert result.images[0].url == "https://x/y.png"


def test_reframe_image_run_narrows_completed_type():
    fake = FakeHttp(
        {"id": "t1", "status": "pending"},
        {"id": "t1", "status": "completed", "images": [{"url": "https://x/r.png"}]},
    )
    client = IdeogramV3Client(api_key="k", http_client=fake)
    result = client.reframe_image.run(
        model="ideogram-v3-reframe", source_image_url="https://x/a.png", aspect_ratio="16:9"
    )
    assert isinstance(result, CompletedIdeogramResponse)
    assert result.images[0].url == "https://x/r.png"


# --- validation: model + shared --------------------------------------------


def test_text_to_image_rejects_unknown_model():
    client = IdeogramV3Client(api_key="k", http_client=FakeHttp())
    with pytest.raises(
        ValidationError,
        match="model must be one of: ideogram-v3-character, ideogram-v3-text-to-image",
    ):
        client.text_to_image.create(model="nope", prompt="hi there")


def test_text_to_image_requires_prompt():
    client = IdeogramV3Client(api_key="k", http_client=FakeHttp())
    with pytest.raises(ValidationError, match="prompt is required"):
        client.text_to_image.create(model="ideogram-v3-text-to-image")


def test_text_to_image_rejects_invalid_style_enum():
    client = IdeogramV3Client(api_key="k", http_client=FakeHttp())
    with pytest.raises(
        ValidationError, match="style must be one of: auto, general, realistic, design"
    ):
        client.text_to_image.create(
            model="ideogram-v3-text-to-image", prompt="hi there", style="bogus"
        )


def test_text_to_image_output_count_enum():
    client = IdeogramV3Client(api_key="k", http_client=FakeHttp())
    with pytest.raises(ValidationError, match="output_count must be one of: 1, 2, 3, 4"):
        client.text_to_image.create(
            model="ideogram-v3-text-to-image", prompt="hi there", output_count=9
        )


def test_character_model_requires_reference_image_urls():
    client = IdeogramV3Client(api_key="k", http_client=FakeHttp())
    with pytest.raises(ValidationError, match="reference_image_urls is required"):
        client.text_to_image.create(model="ideogram-v3-character", prompt="hi there")


def test_text_to_image_rejects_reference_image_urls_for_base_model():
    client = IdeogramV3Client(api_key="k", http_client=FakeHttp())
    with pytest.raises(
        ValidationError, match="reference_image_urls is not supported for ideogram-v3-text-to-image"
    ):
        client.text_to_image.create(
            model="ideogram-v3-text-to-image",
            prompt="hi there",
            reference_image_urls=["https://x/a.png"],
        )


# --- validation: edit ------------------------------------------------------


def test_edit_requires_source_and_mask():
    client = IdeogramV3Client(api_key="k", http_client=FakeHttp())
    with pytest.raises(ValidationError, match="source_image_url is required"):
        client.edit_image.create(
            model="ideogram-v3-edit", prompt="x", mask_url="https://x/m.png"
        )
    with pytest.raises(ValidationError, match="mask_url is required"):
        client.edit_image.create(
            model="ideogram-v3-edit", prompt="x", source_image_url="https://x/a.png"
        )


def test_edit_rejects_character_fields_for_base_model():
    client = IdeogramV3Client(api_key="k", http_client=FakeHttp())
    with pytest.raises(
        ValidationError, match="character edit fields are not supported for ideogram-v3-edit"
    ):
        client.edit_image.create(
            model="ideogram-v3-edit",
            prompt="x",
            source_image_url="https://x/a.png",
            mask_url="https://x/m.png",
            style="auto",
        )


# --- validation: remix -----------------------------------------------------


def test_remix_requires_source_image_url():
    client = IdeogramV3Client(api_key="k", http_client=FakeHttp())
    with pytest.raises(ValidationError, match="source_image_url is required"):
        client.remix_image.create(model="ideogram-v3-remix", prompt="x")


def test_remix_strength_out_of_range():
    client = IdeogramV3Client(api_key="k", http_client=FakeHttp())
    with pytest.raises(ValidationError, match="strength must be between 0.01 and 1.0"):
        client.remix_image.create(
            model="ideogram-v3-remix",
            prompt="x",
            source_image_url="https://x/a.png",
            strength=2,
        )


def test_remix_character_strength_min_differs():
    client = IdeogramV3Client(api_key="k", http_client=FakeHttp())
    with pytest.raises(ValidationError, match="strength must be between 0.1 and 1.0"):
        client.remix_image.create(
            model="ideogram-v3-character-remix",
            prompt="x",
            source_image_url="https://x/a.png",
            reference_image_urls=["https://x/r.png"],
            strength=0.05,
        )


def test_remix_rejects_character_fields_for_base_model():
    client = IdeogramV3Client(api_key="k", http_client=FakeHttp())
    with pytest.raises(
        ValidationError, match="character remix fields are not supported for ideogram-v3-remix"
    ):
        client.remix_image.create(
            model="ideogram-v3-remix",
            prompt="x",
            source_image_url="https://x/a.png",
            reference_image_urls=["https://x/r.png"],
        )


# --- validation: reframe ---------------------------------------------------


def test_reframe_rejects_unknown_model():
    client = IdeogramV3Client(api_key="k", http_client=FakeHttp())
    with pytest.raises(ValidationError, match="model must be one of: ideogram-v3-reframe"):
        client.reframe_image.create(
            model="ideogram-v3-remix", source_image_url="https://x/a.png", aspect_ratio="1:1"
        )


def test_reframe_requires_aspect_ratio():
    client = IdeogramV3Client(api_key="k", http_client=FakeHttp())
    with pytest.raises(ValidationError, match="aspect_ratio is required"):
        client.reframe_image.create(
            model="ideogram-v3-reframe", source_image_url="https://x/a.png"
        )


def test_reframe_rejects_invalid_aspect_ratio_enum():
    client = IdeogramV3Client(api_key="k", http_client=FakeHttp())
    with pytest.raises(
        ValidationError, match="aspect_ratio must be one of: 1:1, 3:4, 9:16, 4:3, 16:9"
    ):
        client.reframe_image.create(
            model="ideogram-v3-reframe", source_image_url="https://x/a.png", aspect_ratio="21:9"
        )
