package ideogramv3

import (
	"context"
	"encoding/json"
	"testing"

	"github.com/runapi-ai/core-sdk/go/core"
)

type stubHTTPClient struct {
	method string
	path   string
	body   any
}

func (s *stubHTTPClient) Request(_ context.Context, method, path string, opts *core.HTTPRequestOptions) (json.RawMessage, error) {
	s.method = method
	s.path = path
	if opts != nil {
		s.body = opts.Body
	}
	return json.RawMessage(`{"id":"task_123","status":"processing"}`), nil
}

func TestTextToImageCreate(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	_, err := client.TextToImage.Create(context.Background(), TextToImageParams{
		Model:          ModelTextToImage,
		Prompt:         "a lake",
		RenderingSpeed: RenderingBalanced,
		AspectRatio:    AspectRatio1x1,
	})
	if err != nil {
		t.Fatal(err)
	}
	if stub.method != "POST" || stub.path != "/api/v1/ideogram_v3/text_to_image" {
		t.Fatalf("unexpected request: %s %s", stub.method, stub.path)
	}
	body := stub.body.(map[string]any)
	if body["model"] != string(ModelTextToImage) || body["rendering_speed"] != "balanced" || body["aspect_ratio"] != string(AspectRatio1x1) {
		t.Fatalf("unexpected body: %#v", body)
	}
	if _, ok := body["image_size"]; ok {
		t.Fatalf("expected request body to omit image_size, got %#v", body)
	}
}

func TestTextToImageCreateSendsCharacterReferences(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	_, err := client.TextToImage.Create(context.Background(), TextToImageParams{
		Model:              ModelCharacter,
		Prompt:             "a character in a garden",
		ReferenceImageURLs: []string{"https://x/ref.webp"},
		Style:              StyleFiction,
		OutputCount:        2,
	})
	if err != nil {
		t.Fatal(err)
	}
	body := stub.body.(map[string]any)
	if body["model"] != string(ModelCharacter) || body["style"] != "fiction" {
		t.Fatalf("unexpected body: %#v", body)
	}
	refs := stringSlice(body["reference_image_urls"])
	if len(refs) != 1 || refs[0] != "https://x/ref.webp" {
		t.Fatalf("unexpected reference_image_urls: %#v", body["reference_image_urls"])
	}
}

func TestEditImageCreateSendsImageAndMask(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	_, err := client.EditImage.Create(context.Background(), EditImageParams{
		Model:          ModelEdit,
		Prompt:         "cowboy hat",
		SourceImageURL: "https://x/a.png",
		MaskURL:        "https://x/m.png",
	})
	if err != nil {
		t.Fatal(err)
	}
	if stub.method != "POST" || stub.path != "/api/v1/ideogram_v3/edit_image" {
		t.Fatalf("unexpected request: %s %s", stub.method, stub.path)
	}
	body := stub.body.(map[string]any)
	if body["source_image_url"] != "https://x/a.png" || body["mask_url"] != "https://x/m.png" {
		t.Fatalf("unexpected body: %#v", body)
	}
}

func TestEditImageCreateSendsCharacterReferences(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	_, err := client.EditImage.Create(context.Background(), EditImageParams{
		Model:              ModelCharEdit,
		Prompt:             "smile",
		SourceImageURL:     "https://x/a.png",
		MaskURL:            "https://x/m.png",
		ReferenceImageURLs: []string{"https://x/ref.webp"},
		OutputCount:        2,
	})
	if err != nil {
		t.Fatal(err)
	}
	body := stub.body.(map[string]any)
	if body["model"] != string(ModelCharEdit) || body["output_count"] != float64(2) {
		t.Fatalf("unexpected body: %#v", body)
	}
}

func TestRemixImageCreateSendsOutputCountAndStrength(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	strength := 0.8
	_, err := client.RemixImage.Create(context.Background(), RemixImageParams{
		Model:          ModelRemix,
		Prompt:         "remix",
		SourceImageURL: "https://x/i.png",
		OutputCount:    2,
		Strength:       &strength,
	})
	if err != nil {
		t.Fatal(err)
	}
	body := stub.body.(map[string]any)
	if body["output_count"] != float64(2) {
		t.Fatalf("expected output_count=2, got %#v", body["output_count"])
	}
	if body["strength"] != 0.8 {
		t.Fatalf("expected strength=0.8, got %#v", body["strength"])
	}
}

func TestRemixImageCreateSendsCharacterReferences(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	_, err := client.RemixImage.Create(context.Background(), RemixImageParams{
		Model:                   ModelCharRemix,
		Prompt:                  "restyle",
		SourceImageURL:          "https://x/i.png",
		ReferenceImageURLs:      []string{"https://x/character.webp"},
		StyleReferenceImageURLs: []string{"https://x/style.webp"},
		ReferenceMaskURLs:       []string{"https://x/mask.webp"},
	})
	if err != nil {
		t.Fatal(err)
	}
	body := stub.body.(map[string]any)
	if body["model"] != string(ModelCharRemix) ||
		stringSlice(body["style_reference_image_urls"])[0] != "https://x/style.webp" ||
		stringSlice(body["reference_mask_urls"])[0] != "https://x/mask.webp" {
		t.Fatalf("unexpected body: %#v", body)
	}
}

func TestReframeImageCreate(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	_, err := client.ReframeImage.Create(context.Background(), ReframeImageParams{
		Model:          ModelReframe,
		SourceImageURL: "https://x/source.png",
		AspectRatio:    AspectRatio3x4,
		RenderingSpeed: RenderingQuality,
	})
	if err != nil {
		t.Fatal(err)
	}
	if stub.method != "POST" || stub.path != "/api/v1/ideogram_v3/reframe_image" {
		t.Fatalf("unexpected request: %s %s", stub.method, stub.path)
	}
	body := stub.body.(map[string]any)
	if body["model"] != string(ModelReframe) || body["aspect_ratio"] != string(AspectRatio3x4) {
		t.Fatalf("unexpected body: %#v", body)
	}
	if _, ok := body["image_size"]; ok {
		t.Fatalf("expected request body to omit image_size, got %#v", body)
	}
}

func TestTextToImageGet(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	_, err := client.TextToImage.Get(context.Background(), "task_abc")
	if err != nil {
		t.Fatal(err)
	}
	if stub.method != "GET" || stub.path != "/api/v1/ideogram_v3/text_to_image/task_abc" {
		t.Fatalf("unexpected request: %s %s", stub.method, stub.path)
	}
}

func stringSlice(value any) []string {
	switch refs := value.(type) {
	case []string:
		return refs
	case []any:
		result := make([]string, 0, len(refs))
		for _, ref := range refs {
			result = append(result, ref.(string))
		}
		return result
	default:
		return nil
	}
}
