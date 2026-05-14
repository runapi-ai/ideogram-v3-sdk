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

func TestGenerationsCreate(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	_, err := client.Generations.Create(context.Background(), GenerationParams{
		Model:          ModelTextToImage,
		Prompt:         "a lake",
		RenderingSpeed: RenderingBalanced,
		ImageSize:      ImageSizeSquareHD,
	})
	if err != nil {
		t.Fatal(err)
	}
	if stub.method != "POST" || stub.path != "/api/v1/ideogram_v3/generations" {
		t.Fatalf("unexpected request: %s %s", stub.method, stub.path)
	}
	body := stub.body.(map[string]any)
	if body["model"] != string(ModelTextToImage) || body["rendering_speed"] != "BALANCED" {
		t.Fatalf("unexpected body: %#v", body)
	}
}

func TestEditsCreateSendsImageAndMask(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	_, err := client.Edits.Create(context.Background(), EditParams{
		Model:    ModelEdit,
		Prompt:   "cowboy hat",
		ImageURL: "https://x/a.png",
		MaskURL:  "https://x/m.png",
	})
	if err != nil {
		t.Fatal(err)
	}
	if stub.method != "POST" || stub.path != "/api/v1/ideogram_v3/edits" {
		t.Fatalf("unexpected request: %s %s", stub.method, stub.path)
	}
	body := stub.body.(map[string]any)
	if body["image_url"] != "https://x/a.png" || body["mask_url"] != "https://x/m.png" {
		t.Fatalf("unexpected body: %#v", body)
	}
}

func TestRemixesCreateSendsNumImagesAndStrength(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	strength := 0.8
	_, err := client.Remixes.Create(context.Background(), RemixParams{
		Model:     ModelRemix,
		Prompt:    "remix",
		ImageURL:  "https://x/i.png",
		NumImages: "2",
		Strength:  &strength,
	})
	if err != nil {
		t.Fatal(err)
	}
	body := stub.body.(map[string]any)
	if body["num_images"] != "2" {
		t.Fatalf("expected num_images=\"2\", got %#v", body["num_images"])
	}
	if body["strength"] != 0.8 {
		t.Fatalf("expected strength=0.8, got %#v", body["strength"])
	}
}

func TestGenerationsGet(t *testing.T) {
	stub := &stubHTTPClient{}
	client := NewClientWithHTTP(stub)
	_, err := client.Generations.Get(context.Background(), "task_abc")
	if err != nil {
		t.Fatal(err)
	}
	if stub.method != "GET" || stub.path != "/api/v1/ideogram_v3/generations/task_abc" {
		t.Fatalf("unexpected request: %s %s", stub.method, stub.path)
	}
}
